//
//  AddBookViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/21/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTitle: UISearchBar!
    @IBOutlet weak var searchAuthor: UISearchBar!

    
    var tableView = UITableView()
    let searchButton = UIButton()
    var isbnImage = String()
    
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:0 ,y: 0, width: 50, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let tabBarHeight: CGFloat = (self.tabBarController?.tabBar.frame.height)!
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchBookResultsTableViewCell.self, forCellReuseIdentifier: "bookResult")
        tableView.rowHeight = 100
        
        //Search Title
        
        
        searchTitle.translatesAutoresizingMaskIntoConstraints = false
        searchTitle.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        searchTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70).isActive = true
        searchTitle.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchTitle.topAnchor.constraint(equalTo: (view.topAnchor), constant:(navigationBarHeight + 20)).isActive = true

        
        //Search Author
        
        
        searchAuthor.translatesAutoresizingMaskIntoConstraints = false
        searchAuthor.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        searchAuthor.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70).isActive = true
        searchAuthor.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchAuthor.topAnchor.constraint(equalTo: searchTitle.bottomAnchor, constant: 0).isActive = true
        
        
        //Search message button
        
        self.view.addSubview(searchButton)
        searchButton.layer.borderWidth = 2.0
        searchButton.layer.borderColor = UIColor.black.cgColor
        searchButton.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
        searchButton.setTitleColor(UIColor.blue, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonFunc), for: .touchUpInside)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10).isActive = true
        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.30).isActive = true
        searchButton.topAnchor.constraint(equalTo: (view.topAnchor), constant: (navigationBarHeight + 20)).isActive = true
        
        
        
        //TableView
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchAuthor.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight).isActive = true
        
        
        activityIndicator()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    func activityIndicator() {
        
        indicator.color = UIColor .magenta
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    
    
    func searchButtonFunc(sender: UIButton!) {
        
        indicator.startAnimating()
        
        let queue = OperationQueue()
        queue.name = "Download Image"
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        
        let request = BookDataStore.shared.getBookResults(with: searchTitle.text!, authorQuery: searchAuthor.text!) { (success) in
            
            if success == true && queue.operationCount == 0{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                }
            }
        }
        
        queue.addOperation { request }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BookDataStore.shared.bookArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookResult", for: indexPath) as! SearchBookResultsTableViewCell
        
        if cell.searchResultView.delegate == nil { cell.searchResultView.delegate = self }

        cell.searchResultView.searchedBook = BookDataStore.shared.bookArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addRatingAndComment" , sender: self)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "addRatingAndComment" {
            let targetController = segue.destination as! AddCommentAndRatingViewController
    
            
            if let indexPath = tableView.indexPathForSelectedRow {

                guard let bookCoverToPass = BookDataStore.shared.bookArray[indexPath.row].bookCover else { print("no cover"); return }
                let titleToPass = BookDataStore.shared.bookArray[indexPath.row].title
                guard let authorToPass = BookDataStore.shared.bookArray[indexPath.row].author else {print("no author"); return}
                guard let imageLinkToPass = BookDataStore.shared.bookArray[indexPath.row].finalBookCoverLink else {print("no image"); return}
                
                var synopsis = String()
                if let downloadedSynopsis = BookDataStore.shared.bookArray[indexPath.row].synopsis {
                    synopsis = downloadedSynopsis
                } else {
                    synopsis = "Synopsis not available"
                    
                }
//                guard let synopsisToPass = BookDataStore.shared.bookArray[indexPath.row].synopsis else { print("no synopsis"); return "Synopsis not available"}
                
//                let selectedBook = SearchedBook(title: titleToPass, author: authorToPass, bookCover: bookCoverToPass, finalBookCoverLink: imageLinkToPass, synopsis: synopsis)
//                targetController.searchedBook = selectedBook
                
                targetController.passedImage = bookCoverToPass
                targetController.passedTitle = titleToPass
                targetController.passedAuthor = authorToPass
                targetController.passedImageLink = imageLinkToPass
                targetController.passedSynopsis = synopsis
            }
        }
        
        
     }
    

    
}

// MARK: - Presentation Methods
extension UIViewController {
    
    func presentAlertWithTitle(title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


extension AddBookViewController: SearchResultDelegate {
    
    func canDisplayImage(sender: SearchResultsView) -> Bool {
        
        guard let viewableIndexPaths = tableView.indexPathsForVisibleRows else { return false }
        
        var books: Set<SearchedBook> = []
        
        for indexPath in viewableIndexPaths {
            
            let currentBook = BookDataStore.shared.bookArray[indexPath.row]
            
            books.insert(currentBook)
            
        }
        
        return books.contains(sender.searchedBook)
        
    }
    
    
}






