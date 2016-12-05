//
//  ImagePicker.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/5/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func configureProfileView() {
        
        followersFollowingView.profilePic.image = UIImage(named: "BFFLogo")
        followersFollowingView.profilePic.translatesAutoresizingMaskIntoConstraints = false
        followersFollowingView.profilePic.contentMode = .scaleAspectFill
        
        followersFollowingView.profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        followersFollowingView.profilePic.isUserInteractionEnabled = true
        
        
    }
    
    
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
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

    
}

