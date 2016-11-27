//
//  PostsFirebaseMethods.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/26/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import Firebase

class PostsFirebaseMethods {
    
    // MARK: - Download posts from Firebase
    
    static func downloadAllPosts(with completion: @escaping ([BookPosted]) -> Void) {
        
        let postRef = FIRDatabase.database().reference().child("posts")
        
        var postsArray = [BookPosted]()
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("download all posts error"); return}
            
            for snap in snapshotValue {
                
                let bookUniqueID = snap.key
                
                guard
                    let postInfo = snap.value as? [String: String],
                    let comment = postInfo["comment"],
                    let imageLink = postInfo["imageLink"],
                    let rating = postInfo["rating"],
                    let userUniqueID = postInfo["userUniqueID"],
                    let timestampString = postInfo["timestamp"],
                    let timestamp = Double(timestampString)
                    else {print("error downloading postInfo"); return}
                
                let post = BookPosted(bookUniqueID: bookUniqueID, rating: rating, comment: comment, imageLink: imageLink, timestamp: timestamp, userUniqueKey: userUniqueID)
                postsArray.append(post)
            }
            
            postsArray.sort(by: { (first, second) -> Bool in
                return first.timestamp > second.timestamp
            })
            
            if postsArray.count > 0 {
                completion(postsArray)
            }
            
        })
    }
    
    
    static func downloadSynopsisOfBookWith(book uniqueID: String, completion: @escaping (String) -> Void) {
        
        let bookRef = FIRDatabase.database().reference().child("books").child(uniqueID)
        
        bookRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: Any] else {return}
            
            guard let synopsis = snapshotValue["synopsis"] as? String else {print("error downloading synopsis"); return}
            completion(synopsis)
        })
    }
    
    
    
    // MARK: - Add & remove books to book list
    
    static func addBookToFutureReadsWith(book uniqueID: String, imageLink: String, completion: () -> Void) {
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else {return}
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueID).child("futureReads")
        
        userRef.updateChildValues([uniqueID: ["futureRead": true, "imageLink": imageLink]])
        
        completion()
    }
    
    static func removeBookFromFutureReadsWith(book uniqueID: String, completion: () -> Void) {
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else {return}
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueID).child("futureReads")
        
        userRef.updateChildValues([uniqueID: false])
        
        completion()
        
    }
    
    
    
    // MARK: - Prevent duplicates on Firebase & book list
    
    static func checkIfAlreadyAddedBookToFutureReadsWith(book uniqueID: String, completion: @escaping (Bool) -> Void) {
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else {return}
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueID).child("futureReads")
        var boolToReturn = false
        var bookIDsArray = [String]()
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("error downloading futureReads"); return}
            
            for snap in snapshotValue {
                
                bookIDsArray.append(snap.key)
                
            }
            
            if bookIDsArray.contains(uniqueID) {
                boolToReturn = true
            } else {
                boolToReturn = false
            }
            
            completion(boolToReturn)
            
        })
        
    }
    
    
    static func checkIfFutureReadsIsEmpty(with completion: @escaping (Bool) -> Void) {
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else {return}
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueID).child("futureReads")
        
        var boolToReturn = false
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.hasChildren() {
                boolToReturn = true
            } else {
                boolToReturn = false
            }
            completion(boolToReturn)
        })
        
    }
    
    static func downloadUsersFutureReadsBookLinkIDArray(with completion: @escaping ([String]) -> Void) {
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else {return}
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueID).child("futureReads")
        var bookLinkIDArray = [String]()
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshotValue = snapshot.value as? [String: Any] else {return}
            print(snapshotValue)
            for snap in snapshotValue {
                
                print(snap)
                
                guard
                    let postInfo = snap.value as? [String: Any],
                    let imageLink = postInfo["imageLink"] as? String
                    else { print("error downloading image link"); return}
                
                bookLinkIDArray.append(imageLink)
                
            }
            print(bookLinkIDArray.count)
            completion(bookLinkIDArray)
        })
    }
}
