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
        
        let postRef = FIRDatabase.database().reference().child("posts").child("visible")
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else {return}
        
        var postsArray = [BookPosted]()
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: Any] else {print("download all posts error"); return}
            
            for snap in snapshotValue {
                
                guard
                    let postInfo = snap.value as? [String: Any],
                    let comment = postInfo["comment"] as? String,
                    let imageLink = postInfo["imageLink"] as? String,
                    let rating = postInfo["rating"] as? String,
                    let userUniqueID = postInfo["userUniqueID"] as? String,
                    let timestampString = postInfo["timestamp"] as? String,
                    let timestamp = Double(timestampString),
                    let bookUniqueID = postInfo["bookUniqueKey"] as? String,
                    let title = postInfo["title"] as? String,
                    let reviewID = postInfo["reviewID"] as? String
                    else {print("error downloading postInfo"); return}
                
                if userUniqueID != currentUserID {
                    let post = BookPosted(bookUniqueID: bookUniqueID, rating: rating, comment: comment, imageLink: imageLink, timestamp: timestamp, userUniqueKey: userUniqueID, reviewID: reviewID, title: title)
                    postsArray.append(post)
                }
                
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
    
    
    static func downloadFollowingPosts(with userUniqueID: String, completion: @escaping ([BookPosted]) -> Void) {
        
        let postRef = FIRDatabase.database().reference().child("posts").child("visible")
        
        var postsArray = [BookPosted]()
        var followingUniqueIDArray = [String]()
        
        UserFirebaseMethods.retriveFollowingUsers(with: userUniqueID) { (followingArray) in
            guard let array = followingArray else { return }
            for user in array {
                followingUniqueIDArray.append(user.uniqueKey)
            }
            
            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snapshotValue = snapshot.value as? [String: Any] else {print("download all posts error"); return}
                
                for snap in snapshotValue {
                    
                    guard
                        let postInfo = snap.value as? [String: Any],
                        let comment = postInfo["comment"] as? String,
                        let imageLink = postInfo["imageLink"] as? String,
                        let rating = postInfo["rating"] as? String,
                        let userUniqueID = postInfo["userUniqueID"] as? String,
                        let timestampString = postInfo["timestamp"] as? String,
                        let timestamp = Double(timestampString),
                        let bookUniqueID = postInfo["bookUniqueKey"] as? String,
                        let title = postInfo["title"] as? String,
                        let reviewID = postInfo["reviewID"] as? String
                        else {print("error downloading postInfo"); return}
                    
                    if followingUniqueIDArray.contains(userUniqueID) {
                        let post = BookPosted(bookUniqueID: bookUniqueID, rating: rating, comment: comment, imageLink: imageLink, timestamp: timestamp, userUniqueKey: userUniqueID, reviewID: reviewID, title: title)
                        postsArray.append(post)
                    }
                    
                    print("POST ARRAY: \(postsArray)")
                }
                
                postsArray.sort(by: { (first, second) -> Bool in
                    return first.timestamp > second.timestamp
                })
                
                if postsArray.count > 0 {
                    completion(postsArray)
                }
            })
        }
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
        
        userRef.child(uniqueID).removeValue()
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
    
    static func downloadUsersFutureReadsBookLinkIDArray(with completion: @escaping ([String], [String]) -> Void) {
        
        guard let userUniqueID = FIRAuth.auth()?.currentUser?.uid else {return}
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueID).child("futureReads")
        var bookLinkIDArray = [String]()
        var bookIDArray = [String]()
        
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
                bookIDArray.append(snap.key)
                
            }
            print(bookLinkIDArray.count)
            completion(bookLinkIDArray, bookIDArray)
        })
    }
    
    
    static func checkIfAnyBookPostsExist(with completion: @escaping (Bool) -> Void) {
        let postRef = FIRDatabase.database().reference().child("posts").child("visible")
        var postsExist = false
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            DispatchQueue.main.async {
                
                completion(snapshot.hasChildren())
                
            }
        })
    }
    
    
    static func downloadUsersBookPostsArray(with userUniqueKey: String, completion: @escaping ([BookPosted]?) -> Void) {
        
        let postRef = FIRDatabase.database().reference().child("posts").child("visible")
        var postsArray = [BookPosted]()
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            DispatchQueue.main.async {
                
                guard let snapshotValue = snapshot.value as? [String: Any] else { print("download all posts error"); completion(nil); return }
                
                for snap in snapshotValue {
                    
                    guard
                        let postInfo = snap.value as? [String: Any],
                        let comment = postInfo["comment"] as? String,
                        let imageLink = postInfo["imageLink"] as? String,
                        let rating = postInfo["rating"] as? String,
                        let userUniqueID = postInfo["userUniqueID"] as? String,
                        let timestampString = postInfo["timestamp"] as? String,
                        let timestamp = Double(timestampString),
                        let bookUniqueID = postInfo["bookUniqueKey"] as? String,
                        let title = postInfo["title"] as? String,
                        let reviewID = postInfo["reviewID"] as? String
                        else {print("error downloading postInfo"); return}
                    
                    if userUniqueID == userUniqueKey {
                        let post = BookPosted(bookUniqueID: bookUniqueID, rating: rating, comment: comment, imageLink: imageLink, timestamp: timestamp, userUniqueKey: userUniqueID, reviewID: reviewID, title: title)
                        postsArray.append(post)
                    }
                }
                
                postsArray.sort(by: { (first, second) -> Bool in
                    return first.timestamp > second.timestamp
                })
                
                completion(postsArray)
                
                
            }
        })
    }
    
    
    // MARK: - Flag posts
    
    static func flagPostsWith(book post: BookPosted, completion: @escaping () -> Void) {
        
        let userRef = FIRDatabase.database().reference().child("users").child(post.userUniqueKey).child("previousReads")
        let postRef = FIRDatabase.database().reference().child("posts").child("visible")
        let postFlaggedRef = FIRDatabase.database().reference().child("posts").child("flagged")
        
        userRef.updateChildValues([post.bookUniqueID: ["rating": post.rating, "comment": post.comment, "timestamp": post.timestamp, "imageLink": post.imageLink, "isFlagged": true]])
        
        postFlaggedRef.updateChildValues([post.reviewID: ["rating": post.rating, "comment": post.comment, "timestamp": post.timestamp, "imageLink": post.imageLink, "userUniqueID": post.userUniqueKey, "isFlagged": true, "bookUniqueKey": post.bookUniqueID, "reviewID": post.reviewID, "title": post.title]])
        
        postRef.child(post.reviewID).removeValue()
        
        completion()
        
    }
    
}
