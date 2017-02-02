//
//  BookDetailsViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/26/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import CoreData

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookSynopsis: UITextView!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var addBookButton: UIButton!
    var passedUniqueID = String()
    var passedImageLink = String()
    var passedTitle = String()
    var noInternetView: NoInternetView!
    var amazonLink = String()
    var webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        guard let navBarHeight = self.navigationController?.navigationBar.frame.height else { print("no nav bar height"); return }
        self.noInternetView = NoInternetView(frame: CGRect(x: 0, y: -navBarHeight, width: self.view.frame.width, height: self.view.frame.height))
        
        addBookButton.layer.borderColor = UIColor.themeOrange.cgColor
        addBookButton.layer.borderWidth = 4.0
        addBookButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        addBookButton.layer.cornerRadius = 4.0
        addBookButton.setTitleColor(UIColor.themeOrange, for: .normal)
        addBookButton.titleLabel?.font = UIFont.themeTinyBold
        addBookButton.titleLabel?.numberOfLines = 0
        addBookButton.titleLabel?.lineBreakMode = .byWordWrapping
        addBookButton.titleLabel?.textAlignment = .center
        
        synopsisLabel.font = UIFont.themeSmallBold
        synopsisLabel.textColor = UIColor.themeOrange
        
        bookSynopsis.font = UIFont.themeSmallThin
        bookSynopsis.textColor = UIColor.themeDarkBlue
        bookImageView.loadImageUsingCacheWithURLString(urlString: passedImageLink)
        
        if Reachability.isConnectedToNetwork() == true {
            PostsFirebaseMethods.downloadSynopsisAndAuthorOfBookWith(book: passedUniqueID) { (synopsis, author) in
                self.bookSynopsis.text = synopsis
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
    
    func generateProperAmazonTitleSearch(with searchTitle: String) {
        
        let correctTitle = searchTitle.replacingOccurrences(of: " ", with: "+")
        amazonLink = "https://www.amazon.com/gp/search?ie=UTF8&tag=fjoh-20&linkCode=ur2&linkId=843dbc767a8fd5beb8c8addbc0d75569&camp=1789&creative=9325&index=books&keywords=\(correctTitle)"
        print("AMAZON LINK: \(amazonLink)")
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
    
    @IBAction func puchaseOnAmazonButton(_ sender: Any) {
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
}
