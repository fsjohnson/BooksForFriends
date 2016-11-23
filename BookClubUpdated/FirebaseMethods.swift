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
    
}
