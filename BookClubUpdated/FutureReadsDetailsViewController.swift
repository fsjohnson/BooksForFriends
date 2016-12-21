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
    
    @IBOutlet weak var synopsisLabel: UILabel!
    var passedUniqueID = String()
    var passedImageLink = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
//        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        synopsisLabel.font = UIFont.themeSmallBold
        synopsisLabel.textColor = UIColor.themeOrange
        
        bookSynopsis.font = UIFont.themeSmallThin
        bookSynopsis.textColor = UIColor.themeDarkBlue
        bookImageView.loadImageUsingCacheWithURLString(urlString: passedImageLink)
        
        PostsFirebaseMethods.downloadSynopsisOfBookWith(book: passedUniqueID) { (synopsis) in
            print(synopsis)
            self.bookSynopsis.text = synopsis
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
