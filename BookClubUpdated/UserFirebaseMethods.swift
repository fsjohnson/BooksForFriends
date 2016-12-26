//
//  UsersFirebaseMethods.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/24/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import Firebase

class UserFirebaseMethods {
    
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
    
    
    static func signUpButton(email: String, password: String, name: String, username: String, completion: @escaping (Bool) -> () ) {
        
        let ref = FIRDatabase.database().reference().root
        var boolToPass = false
        
        if email != "" && password != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    let userDictionary = ["email": email, "name": name, "username": username, "uniqueKey": (user?.uid)!, "profilePicURL": "no image"]
                    
                    ref.child("users").child((user?.uid)!).setValue(userDictionary)
                    boolToPass = true
                    completion(boolToPass)
                    
                } else {
                    print(error?.localizedDescription ?? "")
                    boolToPass = false
                    completion(boolToPass)
                }
            })
        }
    }
    
    
    //MARK: - Retrieve users
    
    
    static func retrieveAllUsers(with completion: @escaping ([User?])-> Void) {
        
        let userRef = FIRDatabase.database().reference().child("users")
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        var usersArray = [User]()
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userRawInfo = snapshot.value as? [String:Any] else {return}
            
            for userValue in userRawInfo {
                
                print(userValue)
                
                guard
                    let userInfo = userValue.value as? [String: Any],
                    let name = userInfo["name"] as?  String,
                    let username = userInfo["username"] as? String,
                    let email = userInfo["email"] as? String,
                    let uniqueKey = userInfo["uniqueKey"] as? String,
                    let profileImageURL = userInfo["profilePicURL"] as? String
                    else { print("\n\n\n\n\n\(userRawInfo)\n\n\n\n"); return }
                
                if uniqueKey != currentUser {
                    
                    
                    let user = User(name: name, email: email, uniqueKey: uniqueKey, username: username, profileImageURL: profileImageURL)
                    usersArray.append(user)
                }
            }
            completion(usersArray)
        })
    }
    
    static func retrieveSpecificUser(with uniqueID: String, completion: @escaping (User?)-> Void) {
        
        let userRef = FIRDatabase.database().reference().child("users").child(uniqueID)
        
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let userInfoRaw = snapshot.value as? [String:Any]
            
            guard
                let userInfo = userInfoRaw,
                let name = userInfo["name"] as?  String,
                let username = userInfo["username"] as? String,
                let email = userInfo["email"] as? String,
                let uniqueKey = userInfo["uniqueKey"] as? String,
                let profileImageURL = userInfo["profilePicURL"] as? String
                else { print("\n\n\n\n\n\(userInfoRaw)\n\n\n\n"); return }
            
            
            let user = User(name: name, email: email, uniqueKey: uniqueKey, username: username, profileImageURL: profileImageURL)
            completion(user)
        })
    }
    
    
    //MARK: - Add & remove following / followers
    
    static func addFollowing(with userUniqueKey: String, completion: @escaping (Bool) -> Void) {
        
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let ref = FIRDatabase.database().reference().child("users").child(currentUser).child("following")
        var boolToReturn = false
        
        UserFirebaseMethods.checkIfBlocked(with: userUniqueKey) { (isBlocked) in
            if isBlocked == false {
                
                ref.updateChildValues([userUniqueKey: true])
                
                let followedRef = FIRDatabase.database().reference().child("users").child(userUniqueKey).child("followers").child("notBlocked")
                followedRef.updateChildValues([currentUser:true])
                BFFCoreData.sharedInstance.saveContext()
                boolToReturn = true
                
            } else {
                boolToReturn = false
            }
            print(boolToReturn)
            completion(boolToReturn)
        }
    }
    
    
    static func removeFollowing(with userUniqueKey: String, completion: () -> Void) {
        
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let ref = FIRDatabase.database().reference().child("users").child(currentUser).child("following")
        
        ref.child(userUniqueKey).removeValue()
        
        let followedRef = FIRDatabase.database().reference().child("users").child(userUniqueKey).child("followers").child("notBlocked")
        followedRef.child(currentUser).removeValue()
        //BFFCoreData.sharedInstance.deleteFollowingData(with: userUniqueKey)
        
        completion()
    }
    
    
    // MARK: - Check not already following user
    
    static func prohibitDuplicateFollowing(of uniqueUserID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        let ref = FIRDatabase.database().reference().child("users").child(currentUser).child("following")
        var followingIDArray = String()
        var completionToPass = Bool()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            
            if !snapshot.hasChildren() {
                completionToPass = false
            } else {
                guard let snapshotValue = snapshot.value as? [String: Any] else {return}
                
                for snap in snapshotValue {
                    followingIDArray.append(snap.key)
                }
                
                if followingIDArray.contains(uniqueUserID) {
                    completionToPass = true
                } else {
                    completionToPass = false
                }
                
            }
            completion(completionToPass)
        })
    }
    
    
    //MARK: - Retrive following
    
    static func checkIfFollowingUsersIsEmpty(with completion: @escaping (Bool) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        let ref = FIRDatabase.database().reference().child("users").child(currentUser).child("following")
        var isEmpty = false
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                isEmpty = true
            } else {
                isEmpty = false
            }
            
            completion(isEmpty)
        })
    }
    
    static func retriveFollowingUsers(with userID: String, completion: @escaping ([User]?) -> Void) {
        
        let ref = FIRDatabase.database().reference().child("users").child(userID).child("following")
        var followingUserArray = [User]()
        var followingUserIDArray = [String]()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            DispatchQueue.main.async {
                
                guard let snapshotValue = snapshot.value as? [String: Any] else { print("download followers posts error"); completion(nil); return }
                
                for snap in snapshotValue {
                    followingUserIDArray.append(snap.key)
                }
                
                for id in followingUserIDArray {
                    UserFirebaseMethods.retrieveSpecificUser(with: id, completion: { (user) in
                        followingUserArray.append(user!)
                        
                        if followingUserIDArray.count == followingUserArray.count {
                            completion(followingUserArray)
                        }
                    })
                }
            }
        })
    }
    
    
    //MARK: - Retrieve followers
    
    static func retriveFollowers(with userID: String, completion: @escaping ([User]?) -> Void) {
        
        let ref = FIRDatabase.database().reference().child("users").child(userID).child("followers").child("notBlocked")
        var followersUserArray = [User]()
        var followersUserIDArray = [String]()
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            DispatchQueue.main.async {
                
                guard let snapshotValue = snapshot.value as? [String: Any] else { print("download followers posts error"); completion(nil); return }
                
                
                for snap in snapshotValue {
                    followersUserIDArray.append(snap.key)
                }
                
                for id in followersUserIDArray {
                    UserFirebaseMethods.retrieveSpecificUser(with: id, completion: { (user) in
                        followersUserArray.append(user!)
                        
                        if followersUserIDArray.count == followersUserArray.count {
                            completion(followersUserArray)
                        }
                    })
                }
            }
        })
    }
    
    
    
    // Mark: - Block Follower
    
    static func blockFollower(with userUniqueKey: String, completion: () -> Void) {
        
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let ref = FIRDatabase.database().reference().child("users").child(userUniqueKey).child("following")
        
        ref.child(currentUser).removeValue()
        
        let followedRef = FIRDatabase.database().reference().child("users").child(currentUser).child("followers").child("notBlocked")
        
        let blockedRef = FIRDatabase.database().reference().child("users").child(currentUser).child("followers").child("blocked")
        
        blockedRef.updateChildValues([userUniqueKey:true])
        
        followedRef.child(userUniqueKey).removeValue()
        completion()
    }
    
    // Mark: - Check if blocked
    
    static func checkIfBlocked(with userUniqueKey: String, completion: @escaping (Bool) -> Void) {
        
        let blockedRef = FIRDatabase.database().reference().child("users").child(userUniqueKey).child("followers").child("blocked")
        
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else {return}
        
        var isBlocked = false
        var blockedUsers = [String]()
        
        blockedRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                isBlocked = false
            } else {
                guard let snapshotValue = snapshot.value as? [String: Any] else { print("error returning blocked users"); return }
                for snap in snapshotValue {
                    blockedUsers.append(snap.key)
                }
                
                if blockedUsers.contains(currentUser) {
                    
                    isBlocked = true
                }
            }
            completion(isBlocked)
        })
    }
    
    // MARK: - Comments for BFF

    static func sendFeedbackToBFF(with comment: String) {
        let ref = FIRDatabase.database().reference().child("userFeedback")
        let commentUniqueID = FIRDatabase.database().reference().childByAutoId().key
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        
        ref.updateChildValues([commentUniqueID: ["userUniqueID": currentUser, "comment": comment]])
    }
    
    // MARK: - Change username
    
    static func changeUsername(with userUniqueID: String, username: String, completion: () -> Void) {
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueID)
        userRef.updateChildValues(["username":username])
        completion()
    }
    
}
