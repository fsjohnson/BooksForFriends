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
    var bookAuthor = String()
    var noInternetView: NoInternetView!
    var amazonLink = String()
    var webView = UIWebView()
    
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
        
        guard let navBarHeight = self.navigationController?.navigationBar.frame.height else { print("no nav bar height"); return }
        self.noInternetView = NoInternetView(frame: CGRect(x: 0, y: -navBarHeight, width: self.view.frame.width, height: self.view.frame.height))
        
        if Reachability.isConnectedToNetwork() == true {
            PostsFirebaseMethods.downloadSynopsisAndAuthorOfBookWith(book: passedUniqueID) { (synopsis, author) in
                self.bookSynopsis.text = synopsis
                self.bookAuthor = author
            }
        } else {
            self.view.addSubview(self.noInternetView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            if self.view.subviews.contains(self.noInternetView) {
                self.noInternetView.removeFromSuperview()
            }
        }
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
    
    func generateProperAmazonTitleSearch(with searchTitle: String) {
        
        let correctTitle = searchTitle.replacingOccurrences(of: " ", with: "+")
        amazonLink = "https://www.amazon.com/gp/search?ie=UTF8&tag=fjoh-20&linkCode=ur2&linkId=843dbc767a8fd5beb8c8addbc0d75569&camp=1789&creative=9325&index=books&keywords=\(correctTitle)"
        print("AMAZON LINK: \(amazonLink)")
    }

    @IBAction func amazonPurchaseButton(_ sender: Any) {
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
        } else {
            let alert = UIAlertController(title: "Oops!", message: "URL could not be found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
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
            dest.passedAuthor = bookAuthor
            dest.passedSynopsis = synopsisLabel.text!
            dest.fromFutureReads = true
        }
    }
    
}
