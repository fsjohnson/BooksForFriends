//
//  ImagePicker.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/5/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func handleSelectProfileImageView() {
        print("image touched")
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var seletedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            seletedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            seletedImageFromPicker = originalImage
            
        }
        
        if let selectedImage = seletedImageFromPicker {
            followersFollowingView.profilePic.image = selectedImage
            handleSavingPic()
        }
       
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

    
    func handleSavingPic() {
        
        guard let currentUser = FIRAuth.auth()?.currentUser?.uid else { return }
        let userRef = FIRDatabase.database().reference().child("users").child(currentUser)
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profilePics").child("\(imageName).png")
        guard let imageToUpload = followersFollowingView.profilePic.image else { print("no image"); return }
        
        if let uploadData = UIImagePNGRepresentation(imageToUpload) {
            
            storageRef.put(uploadData, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    print(error ?? String())
                    return
                }
                
                guard let metaDataURL = metadata?.downloadURL()?.absoluteString else { print("no profile image URL"); return }
                
                userRef.updateChildValues(["profilePicURL": metaDataURL])
                
            }
            
        }
        
    }
    
}

