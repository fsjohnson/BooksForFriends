//
//  AddCommentAndRatingViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase

class AddCommentAndRatingViewController: UIViewController {
    
    var passedImage = UIImage()
    var passedTitle = String()
    var passedAuthor = String()
    var passedImageLink = String()
    var passedSynopsis = String()
    
    
    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var commentsTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LINK: \(passedImageLink)")
        print("title: \(passedTitle)")
        print("author: \(passedAuthor)")
        
        
        self.bookCoverImageView.image = self.passedImage
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addBookButton(_ sender: Any) {
        
        let bookToAdd = UserBook(title: passedTitle, author: passedAuthor, synopsis: passedSynopsis)
        
        guard let userUniqueKey = FIRAuth.auth()?.currentUser?.uid else {return}
        let ratingString = String(ratingSlider.value)
        guard let comments = commentsTextField.text else {return}

        
        FirebaseMethods.addBookToPreviouslyRead(rating: ratingString, comment: comments, userBook: bookToAdd) {
            FirebaseMethods.combineDuplicateChecks(with: bookToAdd, completion: { (doesExist, bookID) in
                if doesExist == false {
                    let alert = UIAlertController(title: "Success!", message: "You have added \(self.passedTitle) to your previously read list", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else if doesExist == true {
                    
                    FirebaseMethods.checkIfAlreadyAddedAsPreviousRead(with: bookID, userUniqueKey: userUniqueKey, completion: { (doesExist) in
                        if doesExist == false {
                            let alert = UIAlertController(title: "Success!", message: "You have added \(self.passedTitle) to your previously read list", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else if doesExist == true {
                            let alert = UIAlertController(title: "Oops!", message: "You have already read \(self.passedTitle)", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.dismiss(animated: true, completion: nil)
                                
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            })
        }
    }



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}
