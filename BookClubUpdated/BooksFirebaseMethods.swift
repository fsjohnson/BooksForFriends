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
    
    
    // MARK: - Download books from Firebase
    
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
            
            print("DOWNLOAD ALL BOOK IDs: \(userBookIDArray), \(boolToPass)")
            completion(userBookIDArray, boolToPass)
        })
    }
    
    
    static func downloadAllBooksOnFirebase(with completion: @escaping ([UserBook]) -> Void) {
        
        let bookRef = FIRDatabase.database().reference().child("books")
        var userBookArray = [UserBook]()
        
        bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("Couldn't download \(snapshot.value)"); return}
            
            
            for snap in snapshotValue {
                
                print(snap)
                
                guard let value = snap.value as? [String: Any] else {return}
                print(value)
                guard
                    let title = value["title"] as? String,
                    let author = value["author"] as? String,
                    let synopsis = value["synopsis"] as? String,
                    let bookUniqueKey = value["bookUniqueKey"] as? String
                    else {print("error handling \(value)"); return}
                
                let userBook = UserBook(title: title, author: author, synopsis: synopsis, bookUniqueKey: bookUniqueKey)
                userBookArray.append(userBook)
                
            }
            
            completion(userBookArray)
            
        })
        
    }
    
    
    
    static func downloadPreviousReadsIDArrayForCurrentUser(with completion: @escaping ([String]) -> Void) {
        
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else {print("Couldn't retrieve current user");return}
        let userBookRef = FIRDatabase.database().reference().child("users").child(currentUserID).child("previousReads")
        var previousReadsBookIDArray = [String]()
        var boolToPass = false
        
        
        userBookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("Couldn't download \(snapshot.value)");return}
            
            for snap in snapshotValue {
                previousReadsBookIDArray.append(snap.key)
            }
            
            completion(previousReadsBookIDArray)
        })
    }
    
    
    
    
    static func getBookIDFor(userBook book: UserBook, completion: @escaping (String) -> Void) {
        
        let bookRef = FIRDatabase.database().reference().child("books")
        var bookIDToPass = String()
        
        var titleArray = [String]()
        var authorArray = [String]()
        var synopsisArray = [String]()
        
        
        
        BooksFirebaseMethods.downloadAllBooksOnFirebase { (userBookArray) in
            for userBook in userBookArray {
                print(userBook)
                
                if (userBook.title == book.title && userBook.author == book.author! && userBook.synopsis == book.synopsis!) {
                    bookIDToPass = userBook.bookUniqueKey!
                }
                if bookIDToPass != "" {
                    print("GET BOOK ID: \(bookIDToPass)")
                    completion(bookIDToPass)
                    
                }
                
            }
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
            
            print("CHECK IF BOOK EXISTS: \(boolToReturn)\n\n\n")
            completion(boolToReturn)
            
        }
        
    }
    
    
    static func checkIfCurrentUserAlreadyPosted(previousRead bookID: String, completion: @escaping (Bool) -> Void) {
        
        var completionToPass = false
        
        BooksFirebaseMethods.downloadPreviousReadsIDArrayForCurrentUser { (bookUniqueIDs) in
            if bookUniqueIDs.contains(bookID) {
                completionToPass = true
            } else {
                
                completionToPass = false
            }
            print("CHECK IF USER ALREADY POSTED: \(completionToPass)")
            completion(completionToPass)
        }
    }
    
    
    
    
    
    // MARK: - Add book to previous reads
    
    static func addToPreviousReadsWith(userBook: UserBook, comment: String, rating: String, completion: @escaping (Bool) -> Void) {
        
        guard let userUniqueKey = FIRAuth.auth()?.currentUser?.uid else {return}
        //        let bookUniqueKey = FIRDatabase.database().reference().childByAutoId().key
        //
        //        guard let synopsis = userBook.synopsis else {return}
        //        guard let author = userBook.author else {return}
        
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueKey).child("previousReads")
        let bookRef = FIRDatabase.database().reference().child("books")
        
        var boolToSend = false
        
        BooksFirebaseMethods.getBookIDFor(userBook: userBook, completion: { (bookID) in
            print("BOOK ID GENERATED FROM GET BOOK: \(bookID)")
            BooksFirebaseMethods.checkIfCurrentUserAlreadyPosted(previousRead: bookID, completion: { (doesExist) in
                
                print("BOOK ID INSIDE COMPLETION: \(bookID)")
                
                if doesExist == false {
                    
                    userRef.updateChildValues([bookID: ["rating": rating, "comment": comment]])
                    bookRef.child(bookID).child("readByUsers").updateChildValues([userUniqueKey: true])
                    
                    boolToSend = false
                    
                } else {
                    
                    boolToSend = true
                    
                }
                
                completion(boolToSend)
            })
        })
        
    }
    
    
}
