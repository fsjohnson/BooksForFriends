//
//  AddCommentAndRatingViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import Firebase
import Mixpanel

class AddCommentAndRatingViewController: UIViewController {
    
    @IBOutlet weak var addBookButton: UIButton!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var commentsTextView: UITextView!
    
    var passedTitle = String()
    var passedAuthor = String()
    var passedImageLink = String()
    var passedSynopsis = String()
    var passedBookID = String()
    var star = StarReview()
    weak var searchedBook: SearchedBook!
    var fromFutureReads: Bool? = nil
    var passedISBN = String()
    var amazonLink = String()
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        DispatchQueue.main.async {
            self.bookCoverImageView.loadImageUsingCacheWithURLString(urlString: self.passedImageLink)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        print("PASSED ISBN: \(passedISBN)")
        amazonLink = "https://www.amazon.com/gp/search?ie=UTF8&tag=fjoh-20&linkCode=ur2&linkId=843dbc767a8fd5beb8c8addbc0d75569&camp=1789&creative=9325&index=books&keywords=\(passedISBN)"
        print("LINK: \(amazonLink)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func config() {
        let bookToAdd = UserBook(title: passedTitle, author: passedAuthor, synopsis: passedSynopsis, bookUniqueKey: nil, finalBookCoverLink: passedImageLink)
        guard let userUniqueKey = FIRAuth.auth()?.currentUser?.uid else {return}
        BooksFirebaseMethods.getBookIDFor(userBook: bookToAdd) { (bookID) in
            self.passedBookID = bookID
            BooksFirebaseMethods.checkIfCurrentUserAlreadyPosted(previousRead: bookID, userUniqueID: userUniqueKey) { (alreadyPosted) in
                if alreadyPosted == false {
                    self.addBookButton.isHidden = false
                } else {
                    self.addBookButton.isHidden = true
                }
            }
        }
        
        // Mark: - Button config
        addBookButton.layer.borderColor = UIColor.themeOrange.cgColor
        addBookButton.layer.borderWidth = 4.0
        addBookButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        addBookButton.layer.cornerRadius = 4.0
        addBookButton.setTitleColor(UIColor.themeOrange, for: .normal)
        addBookButton.titleLabel?.font = UIFont.themeSmallBold
        
        // Mark: - Rating label config
        ratingLabel.font = UIFont.themeSmallBold
        ratingLabel.textColor = UIColor.themeOrange
        
        // Mark: - Comment label config
        commentsLabel.font = UIFont.themeSmallBold
        commentsLabel.textColor = UIColor.themeOrange
        
        // Mark: - Comment textfield config
        commentsTextView.font = UIFont.themeSmallThin
        commentsTextView.textColor = UIColor.themeDarkBlue
        commentsTextView.textContainer.lineBreakMode = .byWordWrapping
        commentsTextView.layer.borderWidth = 0.5
        commentsTextView.layer.borderColor = UIColor.themeLightGrey.cgColor
        
        
        // Mark: - Star config
        star = StarReview(frame: CGRect(x: 0, y: 0, width: starView.bounds.width.multiplied(by: 0.8), height: starView.bounds.height))
        star.starCount = 5
        star.value = 1
        star.allowAccruteStars = false
        star.allowEdit = true
        star.starFillColor = UIColor.themeDarkBlue
        star.starBackgroundColor = UIColor.themeLightBlue
        star.starMarginScale = 0.3
        starView.addSubview(star)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    @IBAction func addBookButton(_ sender: Any) {
        
        Mixpanel.mainInstance().track(event: "Post Book")
        
        guard let userUniqueKey = FIRAuth.auth()?.currentUser?.uid else {return}
        let ratingString = String(star.value)
        guard let comment = commentsTextView.text else { print("no comment"); return }
        let bookToAdd = UserBook(title: passedTitle, author: passedAuthor, synopsis: passedSynopsis, bookUniqueKey: nil, finalBookCoverLink: passedImageLink)
        
        if commentsTextView.text == "" {
            let alert = UIAlertController(title: "Oops!", message: "Must write a comment before you can submit a post", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            BooksFirebaseMethods.addToPrevious(userBook: bookToAdd, comment: comment, rating: ratingString, userUniqueID: userUniqueKey, imageLink: passedImageLink, bookID: passedBookID, completion: {
                
                let alert = UIAlertController(title: "Success!", message: "You have added \(self.passedTitle) to your previously read list", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                }))
                
                if self.fromFutureReads == true {
                    PostsFirebaseMethods.removeBookFromFutureReads(with: self.passedBookID, completion: {})
                }
                
                self.commentsTextView.text = ""
                self.commentsTextView.resignFirstResponder()
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func generateProperAmazonTitleSearch(with searchTitle: String) {
        
        let correctTitle = searchTitle.replacingOccurrences(of: " ", with: "+")
        amazonLink = "https://www.amazon.com/gp/search?ie=UTF8&tag=fjoh-20&linkCode=ur2&linkId=843dbc767a8fd5beb8c8addbc0d75569&camp=1789&creative=9325&index=books&keywords=\(correctTitle)"
        print("AMAZON LINK: \(amazonLink)")
    }
    
    @IBAction func amazonPurchaseBook(_ sender: Any) {
        generateProperAmazonTitleSearch(with: passedTitle)
        let url = URL(string: "\(amazonLink)")
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    OperationQueue.main.addOperation {
                        self.configWebView()
                        self.webView.loadRequest(request)
                    }
                } else {
                    print("ERROR: \(error)")
                }
            }
            task.resume()
        }
    }
    
    func configWebView() {
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }

}
