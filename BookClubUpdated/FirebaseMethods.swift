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
    
    //MARK: - Download books from Firebase
    
    static func downloadBooksFromFirebase(with completion: @escaping ([String], [String], [String]) -> Void) {
        let ref = FIRDatabase.database().reference().child("books")
        
        var userBookTitleArray = [String]()
        var userBookAuthorArray = [String]()
        var userBookSynopsisArray = [String]()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.hasChildren() {
                userBookTitleArray.append("empty")
                userBookAuthorArray.append("empty")
                userBookSynopsisArray.append("empty")
            } else {
                
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
                
            }
            
            completion(userBookTitleArray, userBookAuthorArray, userBookSynopsisArray)
            
        })
    }
    
    
    //MARK: - Check for duplicates
    
    
    
    static func checkIfBookExistsOnFirebase(with book: UserBook, completion: @escaping (Bool, String) -> Void) {
        
        let ref = FIRDatabase.database().reference().child("books")
        var completionToPass = false
        var bookIDToPass = "need to add"
        
        FirebaseMethods.downloadBooksFromFirebase(with: { (userBookTitleArray, userBookAuthorArray, userBookSynopsisArray) in
            
            if (userBookTitleArray.contains(book.title) && (userBookAuthorArray.contains(book.author!)) && userBookSynopsisArray.contains(book.synopsis!)) {
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let snapshotValue = snapshot.value as? [String: Any] else {print("Snapshot Value: \(snapshot.value) not working"); return}
                    for snap in snapshotValue {
                        bookIDToPass = snap.key
                    }
                    
                    completionToPass = true
                })
            }

                print(completionToPass, bookIDToPass)
                completion(completionToPass, bookIDToPass)
                
        })
        
        
    }
    
    
    static func downloadUsersPreviousReads(with bookUniqueID: String, userUniqueKey: String, completion: @escaping ([String], Bool)-> Void) {
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueKey).child("previousReads")
        let bookRef = FIRDatabase.database().reference().child("books").child(bookUniqueID).child("readByUsers")
        var userIDArray = [String]()
        var boolToPass = Bool()
        
        bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if !snapshot.hasChildren() {
                boolToPass = false
            } else {
                
                guard let snapshotValue = snapshot.value as? [String: Any] else {return}
                print(snapshotValue)
                
                for snap in snapshotValue {
                    print(snap.key)
                    userIDArray.append(snap.key)
                    boolToPass = true
                }
            }
            
            print("PASSED ID ARRAY: \(userIDArray)")
            completion(userIDArray, boolToPass)
            
        })
    }
    
    
    static func checkIfAlreadyAddedAsPreviousRead(with bookUniqueID: String, userUniqueKey: String, completion: @escaping (Bool) -> Void) {
        
        var completionToPass = Bool()
        
        FirebaseMethods.downloadUsersPreviousReads(with: bookUniqueID, userUniqueKey: userUniqueKey) { (userIDArray, hasChildren) in
            
            if hasChildren == true {
                if userIDArray.contains(userUniqueKey) {
                    completionToPass = true
                } else {
                    completionToPass = false
                }
                
            } else {
                completionToPass = false
            }
        }
        
        print(completionToPass)
        completion(completionToPass)
    }
    
}
