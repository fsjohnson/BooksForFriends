//
//  BooksFirebaseMethods.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/25/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import Firebase

class BooksFirebaseMethods {
    
    
    // MARK: - Check if Firebase children are empty
    
    static func checkIfBooksChildIsEmpty(with completion: @escaping (Bool) -> Void) {
        let bookRef = FIRDatabase.database().reference().child("books")
        
        var boolToReturn = false
        
        bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                
                boolToReturn = true
            } else {
                
                boolToReturn = false
            }
            
            completion(boolToReturn)
        })
        
    }
    
    
    static func checkIfCurrentUsersBooksChildIsEmpty(with completion: @escaping (Bool) -> Void) {
        
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let usersBookRef = FIRDatabase.database().reference().child("users").child(currentUser).child("previousReads")
        
        var boolToReturn = false
        
        usersBookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                boolToReturn = true
            } else {
                
                boolToReturn = false
            }
            
            completion(boolToReturn)
        })
        
    }
    
    
    // MARK: - Download books from Firebase
    
    static func downloadAllBookUniqueIDsOnFirebase(with completion: @escaping ([String], Bool) -> Void) {
        
        let bookRef = FIRDatabase.database().reference().child("books")
        var userBookIDArray = [String]()
        var boolToPass = false
        
        bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.hasChildren() {
                boolToPass = false
            } else {
                
                boolToPass = true
                guard let snapshotValue = snapshot.value as? [String: Any] else {print("Couldn't download \(snapshot.value)"); return}
                for snap in snapshotValue {
                    userBookIDArray.append(snap.key)
                }
            }
            
            completion(userBookIDArray, boolToPass)
            
        })
    }
    
    
    static func downloadAllBooksOnFirebase(with completion: @escaping ([UserBook]) -> Void) {
        
        let bookRef = FIRDatabase.database().reference().child("books")
        var userBookArray = [UserBook]()
        
        bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("Couldn't download \(snapshot.value)"); return}
            
            
            for snap in snapshotValue {
                guard let value = snap.value as? [String: Any] else {return}
                print(value)
                guard
                    let title = value["title"] as? String,
                    let author = value["author"] as? String,
                    let synopsis = value["synopsis"] as? String,
                    let finalBookCoverLink = value["imageLink"] as? String,
                    let bookUniqueKey = value["bookUniqueKey"] as? String
                    else {print("error handling \(value)"); return}
                
                let userBook = UserBook(title: title, author: author, synopsis: synopsis, bookUniqueKey: bookUniqueKey, finalBookCoverLink: finalBookCoverLink)
                userBookArray.append(userBook)
                
            }
            
            completion(userBookArray)
            
        })
        
    }
    
    
    
    static func downloadPreviousReadsIDArrayForSpecific(user uniqueID: String, completion: @escaping ([String]?) -> Void) {
        
        let userBookRef = FIRDatabase.database().reference().child("users").child(uniqueID).child("previousReads")
        var previousReadsBookIDArray = [String]()
        
        
        userBookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                completion(nil)
            } else {
                guard let snapshotValue = snapshot.value as? [String: Any] else {print("Couldn't download \(snapshot.value)");return}
                
                for snap in snapshotValue {
                    previousReadsBookIDArray.append(snap.key)
                }
                
                completion(previousReadsBookIDArray)
            }
        })
    }
    
    
    static func getBookIDFor(userBook book: UserBook, completion: @escaping (String) -> Void) {
                
        BooksFirebaseMethods.downloadAllBooksOnFirebase { (userBookArray) in
            
            var ID = String()
            
            for userBook in userBookArray {
                if (userBook.title == book.title && userBook.author == book.author! && userBook.synopsis == book.synopsis!) {
                    ID = userBook.bookUniqueKey!
                }
            }
            
            completion(ID)
        }
    }
    
    
    // MARK: - Prevent duplicates
    
    
    static func checkIfBookExistsOnFirebaseWith(userBook: UserBook, completion: @escaping (Bool) -> Void) {
        
        var userBookTitleArray = [String]()
        var userBookAuthorArray = [String]()
        var userBookSynopsisArray = [String]()
        var boolToReturn = false
        
        BooksFirebaseMethods.downloadAllBooksOnFirebase { (userBookArray) in
            
            for book in userBookArray {
                
                guard
                    let author = book.author,
                    let synopsis = book.synopsis
                    else {print("no author or synopsis"); return}
                
                userBookTitleArray.append(book.title)
                userBookAuthorArray.append(author)
                userBookSynopsisArray.append(synopsis)
                
            }
            
            if ((userBookTitleArray.contains(userBook.title)) && (userBookAuthorArray.contains(userBook.author!)) && (userBookSynopsisArray.contains(userBook.synopsis!))) {
                
                boolToReturn = true
                
            } else {
                
                boolToReturn = false
            }
            
            print("DOES EXIST ON FIREBASE CHECK: \(boolToReturn)")
            completion(boolToReturn)
            
        }
        
    }
    
    
    static func checkIfCurrentUserAlreadyPosted(previousRead bookID: String, userUniqueID: String, completion: @escaping (Bool) -> Void) {
        
        var completionToPass = false
        
        BooksFirebaseMethods.downloadPreviousReadsIDArrayForSpecific(user: userUniqueID) { (bookUniqueIDs) in
            guard let bookUniqueIDArray = bookUniqueIDs else {print("error checking if user already posted"); completion(false); return }
            if bookUniqueIDArray.contains(bookID) {
                completionToPass = true
            } else {
                
                completionToPass = false
            }
            
            completion(completionToPass)
        }
    }
    
    
    // MARK: - Add book to previous reads
    
    static func addToPrevious(userBook: UserBook, comment: String, rating: String, userUniqueID: String, imageLink: String, bookID: String, completion: @escaping () -> Void) {
        
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueID).child("previousReads")
        let bookRef = FIRDatabase.database().reference().child("books")
        let postRef = FIRDatabase.database().reference().child("posts").child("visible")
        let postUniqueKey = FIRDatabase.database().reference().childByAutoId().key
        let bookUniqueKey = FIRDatabase.database().reference().childByAutoId().key
        guard let synopsis = userBook.synopsis else {return}
        guard let author = userBook.author else {return}
        guard let imageLink = userBook.finalBookCoverLink else {print("Couldn't download imageLink: \(userBook.finalBookCoverLink)"); return}
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            BooksFirebaseMethods.checkIfBookExistsOnFirebaseWith(userBook: userBook, completion: { (doesExist) in
                if doesExist == false {
                    
                    userRef.updateChildValues([bookUniqueKey: ["rating": rating, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "isFlagged": false]])
                    bookRef.updateChildValues([bookUniqueKey: ["title": userBook.title, "author": author, "synopsis": synopsis, "readByUsers": [userUniqueID: true], "bookUniqueKey": bookUniqueKey, "imageLink": imageLink]])
                    postRef.updateChildValues([postUniqueKey: ["rating": rating, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "userUniqueID": userUniqueID, "isFlagged": false, "bookUniqueKey": bookUniqueKey, "reviewID": postUniqueKey, "title": userBook.title]])
                } else {
                    
                    userRef.updateChildValues([bookID: ["rating": rating, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "isFlagged": false]])
                    bookRef.child(bookID).child("readByUsers").updateChildValues([userUniqueID: true])
                    postRef.updateChildValues([postUniqueKey: ["rating": rating, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "userUniqueID": userUniqueID, "isFlagged": false, "bookUniqueKey": bookID, "reviewID": postUniqueKey, "title": userBook.title]])
                }
                completion()
            })
            
        })
        
    }
}
