//
//  BookDetailsViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/26/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookSynopsis: UITextView!
    
    var passedImage = UIImage()
    var passedUniqueID = String()
    var passedImageLink = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        bookImageView.image = passedImage
        
        PostsFirebaseMethods.downloadSynopsisOfBookWith(book: passedUniqueID) { (synopsis) in
            print(synopsis)
            self.bookSynopsis.text = synopsis
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addToFutureReads(_ sender: Any) {
        
        PostsFirebaseMethods.checkIfFutureReadsIsEmpty { (isEmpty) in
            if isEmpty == true {
                
                PostsFirebaseMethods.addBookToFutureReadsWith(book: self.passedUniqueID, imageLink: self.passedImageLink, completion: {
                    let alert = UIAlertController(title: "Success!", message: "You have updated your book list", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                                self.dismiss(animated: true, completion: nil)

                    }))
                    self.present(alert, animated: true, completion: nil)
                })
                
            
            } else {
                
                PostsFirebaseMethods.checkIfAlreadyAddedBookToFutureReadsWith(book: self.passedUniqueID, completion: { (doesExist) in
                    if doesExist == false {

                        
                        PostsFirebaseMethods.addBookToFutureReadsWith(book: self.passedUniqueID, imageLink: self.passedImageLink, completion: {
                            let alert = UIAlertController(title: "Success!", message: "You have updated your book list", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        })
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Oops!", message: "You have already added this to your book list", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                })
                
                
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