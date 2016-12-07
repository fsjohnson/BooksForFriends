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
    
    var passedTitle = String()
    var passedAuthor = String()
    var passedImageLink = String()
    var passedSynopsis = String()
    
    @IBOutlet weak var starView: UIView!
    var star = StarReview()
    
    weak var searchedBook: SearchedBook!
    
    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var commentsTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.bookCoverImageView.loadImageUsingCacheWithURLString(urlString: self.passedImageLink)
        }
        
        
        star = StarReview(frame: CGRect(x: 0, y: 0, width: starView.bounds.width, height: starView.bounds.height))
        star.starCount = 5
        star.value = 1
        star.allowAccruteStars = false
        star.starFillColor = UIColor.themeLightBlue
        star.starBackgroundColor = UIColor.themeDarkBlue
        star.starMarginScale = 0.3
        starView.addSubview(star)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    @IBAction func addBookButton(_ sender: Any) {
        
        let bookToAdd = UserBook(title: passedTitle, author: passedAuthor, synopsis: passedSynopsis, bookUniqueKey: nil, finalBookCoverLink: passedImageLink)
        guard let userUniqueKey = FIRAuth.auth()?.currentUser?.uid else {return}
        let ratingString = String(star.value)
        guard let comment = commentsTextField.text else { print("no comment"); return }
        let bookUniqueKey = FIRDatabase.database().reference().childByAutoId().key
        let postUniqueKey = FIRDatabase.database().reference().childByAutoId().key
        
        
        let userRef = FIRDatabase.database().reference().child("users").child(userUniqueKey).child("previousReads")
        let bookRef = FIRDatabase.database().reference().child("books")
        let postRef = FIRDatabase.database().reference().child("posts").child("visible")
        
        guard let synopsis = bookToAdd.synopsis else {return}
        guard let author = bookToAdd.author else {return}
        guard let imageLink = bookToAdd.finalBookCoverLink else {print("Couldn't download imageLink: \(bookToAdd.finalBookCoverLink)"); return}
        
        
        if commentsTextField.text == "" {
            
            let alert = UIAlertController(title: "Oops!", message: "Must write a comment before you can submit a post", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            BooksFirebaseMethods.checkIfBooksChildIsEmpty { (isEmpty) in
                if isEmpty == true {
                    
                    userRef.updateChildValues([bookUniqueKey: ["rating": ratingString, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "isFlagged": false]])
                    bookRef.updateChildValues([bookUniqueKey: ["title": bookToAdd.title, "author": author, "synopsis": synopsis, "readByUsers": [userUniqueKey: true], "bookUniqueKey": bookUniqueKey, "imageLink": imageLink]])
                    postRef.updateChildValues([postUniqueKey: ["rating": ratingString, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "userUniqueID": userUniqueKey, "isFlagged": false, "bookUniqueKey": bookUniqueKey, "reviewID": postUniqueKey, "title": bookToAdd.title]])
                    
                    let alert = UIAlertController(title: "Success!", message: "You have added \(self.passedTitle) to your previously read list", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        
                        //                    self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.commentsTextField.text = ""
                    self.commentsTextField.resignFirstResponder()
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    BooksFirebaseMethods.checkIfBookExistsOnFirebaseWith(userBook: bookToAdd, completion: { (doesExist) in
                        
                        if doesExist == false {
                            
                            userRef.updateChildValues([bookUniqueKey: ["rating": ratingString, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "isFlagged": false]])
                            bookRef.updateChildValues([bookUniqueKey: ["title": bookToAdd.title, "author": author, "synopsis": synopsis, "readByUsers": [userUniqueKey: true], "bookUniqueKey": bookUniqueKey, "imageLink": imageLink]])
                            postRef.updateChildValues([postUniqueKey: ["rating": ratingString, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "userUniqueID": userUniqueKey, "isFlagged": false, "bookUniqueKey": bookUniqueKey, "reviewID": postUniqueKey, "title": bookToAdd.title]])
                            
                            let alert = UIAlertController(title: "Success!", message: "You have added \(self.passedTitle) to your previously read list", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                                //                            self.dismiss(animated: true, completion: nil)
                            }))
                            
                            self.commentsTextField.text = ""
                            self.commentsTextField.resignFirstResponder()
                            
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        } else {
                            
                            BooksFirebaseMethods.getBookIDFor(userBook: bookToAdd, completion: { (bookID) in
                                BooksFirebaseMethods.checkIfCurrentUsersBooksChildIsEmpty(with: { (isEmpty) in
                                    if isEmpty == true {
                                        
                                        
                                        let alert = UIAlertController(title: "Success!", message: "You have added \(self.passedTitle) to your previously read list", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                                            //                                        self.dismiss(animated: true, completion: nil)
                                        }))
                                        
                                        self.commentsTextField.text = ""
                                        self.commentsTextField.resignFirstResponder()
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                        userRef.updateChildValues([bookID: ["rating": ratingString, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "isFlagged": false]])
                                        bookRef.child(bookID).child("readByUsers").updateChildValues([userUniqueKey: true])
                                        postRef.updateChildValues([postUniqueKey: ["rating": ratingString, "comment": comment, "timestamp": String(describing: Date().timeIntervalSince1970), "imageLink": imageLink, "userUniqueID": userUniqueKey, "isFlagged": false, "bookUniqueKey": bookID, "reviewID": postUniqueKey, "title": bookToAdd.title]])
                                        
                                    } else {
                                        
                                        BooksFirebaseMethods.addToPreviousReadsWith(userBook: bookToAdd, comment: comment, rating: ratingString, userUniqueID: userUniqueKey, imageLink: imageLink, completion: { (doesExist) in
                                            if doesExist == false {
                                                
                                                let alert = UIAlertController(title: "Success!", message: "You have added \(self.passedTitle) to your previously read list", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                                                    //                                                self.dismiss(animated: true, completion: nil)
                                                }))
                                                
                                                self.commentsTextField.text = ""
                                                self.commentsTextField.resignFirstResponder()
                                                
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                
                                            } else {
                                                
                                                let alert = UIAlertController(title: "Oops!", message: "You have already posted \(self.passedTitle)", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                                                    //                                                self.dismiss(animated: true, completion: nil)
                                                    
                                                }))
                                                
                                                self.commentsTextField.text = ""
                                                self.commentsTextField.resignFirstResponder()
                                                
                                                self.present(alert, animated: true, completion: nil)
                                                
                                            }
                                        })
                                    }
                                })
                            })
                        }
                        
                    })
                    
                }
            }
            
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
