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
    

    
    
    //MARK: - Check for duplicates
    
    static func checkIfBookExistsOnFirebase(with book: UserBook, completion: @escaping (Bool, String) -> Void) {
        
        let ref = FIRDatabase.database().reference().child("books")
        var completionToPass = Bool()
        var bookIDToPass = String()
        
        var userBookArray = [UserBook]()
        var userBookTitleArray = [String]()
        var userBookAuthorArray = [String]()
        var userBookSynopsisArray = [String]()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                completionToPass = false
                bookIDToPass = "new book id"
                
            } else {
                
                guard let snapshotValue = snapshot.value as? [String: Any] else {print("Snapshot Value: \(snapshot.value) not working"); return}
                print("SNAPSHOT: \(snapshotValue)")
                
                for snap in snapshotValue {
                    guard let value = snap.value as? [String: Any] else {return}
                    guard let key = snap.key as? String else {return}
                    bookIDToPass = key
                    
                    guard
                        let title = value["title"] as? String,
                        let author = value["author"] as? String,
                        let synopsis = value["synopsis"] as? String
                        else {print("error handling \(value)"); return}
                        
                        userBookTitleArray.append(title)
                        userBookAuthorArray.append(author)
                        userBookSynopsisArray.append(synopsis)

                    print("BOOK ARRAY: \(userBookTitleArray.count)")
                }
                
                    print("TITLE VS. ARRAY: \(book.title) vs \(userBookTitleArray)")
                    print("TITLE VS. ARRAY: \(book.author) vs \(userBookAuthorArray)")
                    print("TITLE VS. ARRAY: \(book.synopsis) vs \(userBookSynopsisArray)")
                    print("KEY: \(bookIDToPass)")
                    
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
    
    
    //MARK: - Add previously read book
    
    static func addBookToPreviouslyRead(rating: String, comment: String, userBook: UserBook, completion: () -> Void) {

        let bookUniqueKey = FIRDatabase.database().reference().childByAutoId().key
        guard let usersUniqueKey = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let bookRef = FIRDatabase.database().reference().child("books")
        let usersRef = FIRDatabase.database().reference().child("users").child(usersUniqueKey).child("previousReads")
        
        FirebaseMethods.checkIfBookExistsOnFirebase(with: userBook) { (doesExist, bookID) in
            if doesExist == false {
                usersRef.updateChildValues([bookUniqueKey: ["rating": rating, "comment": comment]])
                bookRef.updateChildValues([bookUniqueKey: ["title": userBook.title, "author": userBook.author, "synopsis": userBook.synopsis]])
                
            } else if doesExist == true {
                usersRef.updateChildValues([bookID: ["rating": rating, "comment": comment]])
                bookRef.child(bookID).child("readByUsers").updateChildValues([usersUniqueKey: true])
                
            }
            
        }
        
        completion()
        
    }
    
    
    
}
