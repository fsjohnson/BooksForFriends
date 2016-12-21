//
//  FutureReadsDetailsViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/16/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class FutureReadsDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookSynopsis: UITextView!
    
    @IBOutlet weak var postBookOutlet: UIButton!
    @IBOutlet weak var deleteBookOutlet: UIButton!
    
    
    @IBOutlet weak var synopsisLabel: UILabel!
    var passedUniqueID = String()
    var passedImageLink = String()
    var passedTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synopsisLabel.font = UIFont.themeSmallBold
        synopsisLabel.textColor = UIColor.themeOrange
        
        bookSynopsis.font = UIFont.themeSmallThin
        bookSynopsis.textColor = UIColor.themeDarkBlue
        bookImageView.loadImageUsingCacheWithURLString(urlString: passedImageLink)
        
        postBookOutlet.layer.borderColor = UIColor.themeOrange.cgColor
        postBookOutlet.layer.borderWidth = 4.0
        postBookOutlet.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        postBookOutlet.layer.cornerRadius = 4.0
        postBookOutlet.setTitleColor(UIColor.themeOrange, for: .normal)
        postBookOutlet.titleLabel?.font = UIFont.themeSmallBold
        
        deleteBookOutlet.setTitleColor(UIColor.themeDarkGrey, for: .normal)
        deleteBookOutlet.titleLabel?.font = UIFont.themeTinyBold
        
        PostsFirebaseMethods.downloadSynopsisOfBookWith(book: passedUniqueID) { (synopsis) in
            print(synopsis)
            self.bookSynopsis.text = synopsis
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteBookAction(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete this book", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.deleteBook()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func deleteBook() {
        let bookToRemove = passedUniqueID
        PostsFirebaseMethods.removeBookFromFutureReads(with: bookToRemove, completion: {
            let alert = UIAlertController(title: "Success!", message: "You have updated your reading list", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBook" {
            let dest = segue.destination as! AddCommentAndRatingViewController
            dest.passedBookID = passedUniqueID
            dest.passedImageLink = passedImageLink
            dest.passedTitle = passedTitle
        }
    }
    
}
