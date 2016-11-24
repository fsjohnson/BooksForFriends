//
//  FirebaseMethods.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/22/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import Firebase

class FirebaseMethods {
    
    //MARK: - Sign Up & Log In Funcs
    
    static func signInButton(email: String, password: String, completion: @escaping (Bool) -> () ) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    static func signUpButton(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Bool) -> () ) {
        
        let ref = FIRDatabase.database().reference().root
        
        if email != "" && password != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    let userDictionary = ["email": email, "firstName": firstName, "lastName": lastName, "uniqueKey": (user?.uid)!]
                    
                    ref.child("users").child((user?.uid)!).setValue(userDictionary)
                    completion(true)
                    
                } else {
                    print(error?.localizedDescription ?? "")
                    completion(false)
                }
            })
        }
    }
    
    //MARK: - Download books from Firebase
    
    static func downloadBooksFromFirebase(with completion: @escaping ([String], [String], [String]) -> Void) {
        let ref = FIRDatabase.database().reference().child("books")
        
        var userBookTitleArray = [String]()
        var userBookAuthorArray = [String]()
        var userBookSynopsisArray = [String]()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("Snapshot Value: \(snapshot.value) not working"); return}
            print("SNAPSHOT: \(snapshotValue)")
            
            for snap in snapshotValue {
                guard let value = snap.value as? [String: Any] else {return}
                
                guard
                    let title = value["title"] as? String,
                    let author = value["author"] as? String,
                    let synopsis = value["synopsis"] as? String
                    else {print("error handling \(value)"); return}
                
                userBookTitleArray.append(title)
                userBookAuthorArray.append(author)
                userBookSynopsisArray.append(synopsis)
            }
            
            completion(userBookTitleArray, userBookAuthorArray, userBookSynopsisArray)
            
        })
    }
    
    //MARK: - Check for duplicates
    
    static func checkIfBookExistsOnFirebase(with userBookTitleArray: [String], userBookAuthorArray: [String], userBookSynopsisArray: [String], book: UserBook, completion: @escaping (Bool, String) -> Void) {
        
        let ref = FIRDatabase.database().reference().child("books")
        var completionToPass = Bool()
        var bookIDToPass = String()
        
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("Snapshot Value: \(snapshot.value) not working"); return}
            for snap in snapshotValue {
                bookIDToPass = snap.key
            }
            
            if !snapshot.hasChildren() {
                completionToPass = false
                bookIDToPass = "new book id"
                
            } else {
                
                if (userBookTitleArray.contains(book.title) && (userBookAuthorArray.contains(book.author!)) && userBookSynopsisArray.contains(book.synopsis!)) {
                    completionToPass = true
                } else {
                    completionToPass = false
                }
                
                print(completionToPass, bookIDToPass)
                completion(completionToPass, bookIDToPass)
                
            }
        })
    }
    
    
    static func downloadUsersPreviousReads(with bookUniqueID: String, userUniqueKey: String, completion: @escaping ([String])-> Void) {
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueKey).child("previousReads")
        let bookRef = FIRDatabase.database().reference().child("books").child(bookUniqueID).child("readByUsers")
        var bookIDArray = [String]()
        var completionToPass = Bool()
        var userIDArray = [String]()
        
        
        bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let snapshotValue = snapshot.value as? [String: Any] else {return}
            print(snapshotValue)
            
            for snap in snapshotValue {
                
                print(snap.key)
                userIDArray.append(snap.key)
            
        }
            print("PASSED ID ARRAY: \(userIDArray)")
            completion(userIDArray)
        
    })
}


static func checkIfAlreadyAddedAsPreviousRead(with bookUniqueID: String, userUniqueKey: String, completion: @escaping (Bool) -> Void) {
    
    var completionToPass = Bool()
    
    
    FirebaseMethods.downloadUsersPreviousReads(with: bookUniqueID, userUniqueKey: userUniqueKey) { (userIDArray) in
        if userIDArray.contains(userUniqueKey) {
            completionToPass = true
        } else {
            completionToPass = false
        }
        
        print(completionToPass)
        completion(completionToPass)
    }
}



static func combineDuplicateChecks(with userBook: UserBook, completion: @escaping (Bool, String) -> Void) {
    
    let bookUniqueKey = FIRDatabase.database().reference().childByAutoId().key
    guard let usersUniqueKey = FIRAuth.auth()?.currentUser?.uid else {return}
    var completionToPass = Bool()
    
    let bookRef = FIRDatabase.database().reference().child("books")
    let usersRef = FIRDatabase.database().reference().child("users").child(usersUniqueKey).child("previousReads")
    
    FirebaseMethods.downloadBooksFromFirebase { (titleArray, authorArray, synopsisArray) in
        FirebaseMethods.checkIfBookExistsOnFirebase(with: titleArray, userBookAuthorArray: authorArray, userBookSynopsisArray: synopsisArray, book: userBook, completion: { (doesExist, bookID) in
            
            print("BOOK ID: \(bookID)")
            
            if doesExist == false {
                completionToPass = false
                
            } else if doesExist == true {
                
                completionToPass = true
            }
            
            print(completionToPass)
            completion(completionToPass, bookID)
        })
        
    }
}



//MARK: - Add previously read book

static func addBookToPreviouslyRead(rating: String, comment: String, userBook: UserBook, completion: @escaping () -> Void) {
    
    let bookUniqueKey = FIRDatabase.database().reference().childByAutoId().key
    guard let usersUniqueKey = FIRAuth.auth()?.currentUser?.uid else {return}
    
    
    let bookRef = FIRDatabase.database().reference().child("books")
    let usersRef = FIRDatabase.database().reference().child("users").child(usersUniqueKey).child("previousReads")
    
    FirebaseMethods.combineDuplicateChecks(with: userBook) { (doesExist, bookID) in
        if doesExist == false {
            usersRef.updateChildValues([bookUniqueKey: ["rating": rating, "comment": comment]])
            bookRef.updateChildValues([bookUniqueKey: ["title": userBook.title, "author": userBook.author, "synopsis": userBook.synopsis, "readByUsers": [usersUniqueKey: true]]])
            
        } else if doesExist == true {
            
            FirebaseMethods.checkIfAlreadyAddedAsPreviousRead(with: bookID, userUniqueKey: usersUniqueKey, completion: { (doesExist) in
                if doesExist == false {
                    usersRef.updateChildValues([bookID: ["rating": rating, "comment": comment]])
                    bookRef.child(bookID).child("readByUsers").updateChildValues([usersUniqueKey: true])
                }
            })
        }
    }
    
    completion()
}

}
