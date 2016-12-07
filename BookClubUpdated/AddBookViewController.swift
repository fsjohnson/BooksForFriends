//
//  AddBookViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/21/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchOptionsView: UIView!
    var tableView = UITableView()
    let searchButton = UIButton()
    var isbnImage = String()
    var segmentedController = UISegmentedControl(items: ["Title", "Title & Author", "Scan Barcode"])
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:0 ,y: 0, width: 50, height: 50))
    let searchTitleBar = UISearchBar()
    let secondSearchTitleBar = UISearchBar()
    let searchAuthorBar = UISearchBar()
    let searchStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let tabBarHeight: CGFloat = (self.tabBarController?.tabBar.frame.height)!
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchBookResultsTableViewCell.self, forCellReuseIdentifier: "bookResult")
        tableView.rowHeight = 100
        
        //Search Options View
        
        searchOptionsView.translatesAutoresizingMaskIntoConstraints = false
        searchOptionsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        searchOptionsView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchOptionsView.topAnchor.constraint(equalTo: (view.topAnchor), constant:(navigationBarHeight + 20)).isActive = true
        searchOptionsView.backgroundColor = UIColor.themeOrange
        
        configSearchTitleView()
        configSearchTitleAuthorView()
        
        // Add search title bar to search opations view
        // Add search title auther bar to search opations view
        // Add search direction text to search options view
        
        configSegmentedControl()
        
        //Search message button
        
        self.view.addSubview(searchButton)
        searchButton.layer.borderWidth = 2.0
        searchButton.layer.borderColor = UIColor.black.cgColor
        searchButton.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonFunc), for: .touchUpInside)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        searchButton.topAnchor.constraint(equalTo: (segmentedController.bottomAnchor)).isActive = true
        //        searchButton.backgroundColor = UIColor.themeOrange
        
        //TableView
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 8).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight).isActive = true
        
        
        activityIndicator()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        searchAuthor.text = ""
        //        searchTitle.text = ""
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
        //        BookDataStore.shared.getBookResults(with: searchTitle.text!, authorQuery: searchAuthor.text!) { (success) in
        //
        //            if success == true {
        //                OperationQueue.main.addOperation {
        //                    self.tableView.reloadData()
        //                    self.indicator.stopAnimating()
        //                    self.indicator.hidesWhenStopped = true
        //
        //                }
        //            }
        //        }
        
    }
    
    func configSegmentedControl() {
        view.addSubview(segmentedController)
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.topAnchor.constraint(equalTo: searchOptionsView.bottomAnchor, constant: 8).isActive = true
        segmentedController.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        segmentedController.addTarget(self, action: #selector(segmentedControlSegues), for: .valueChanged)
        segmentedController.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.themeDarkBlue], for: .normal)
        segmentedController.tintColor = UIColor.themeDarkBlue
        
    }
    
    func segmentedControlSegues(sender: UISegmentedControl!) {
        
        if sender.selectedSegmentIndex == 0 {
            
            self.searchStackView.isHidden = true
            self.searchTitleBar.isHidden = false
        } else if sender.selectedSegmentIndex == 1 {
            
            
            self.searchStackView.isHidden = false
            self.searchTitleBar.isHidden = true
            
        }
    }
    
    func configSearchTitleView() {
        
        searchOptionsView.addSubview(searchTitleBar)
        searchTitleBar.translatesAutoresizingMaskIntoConstraints = false
        searchTitleBar.placeholder = "Search Title"
        searchTitleBar.leadingAnchor.constraint(equalTo: searchOptionsView.leadingAnchor).isActive = true
        searchTitleBar.widthAnchor.constraint(equalTo: searchOptionsView.widthAnchor).isActive = true
        searchTitleBar.bottomAnchor.constraint(equalTo: searchOptionsView.bottomAnchor).isActive = true
        searchTitleBar.tintColor = UIColor.themeOrange
        searchTitleBar.isHidden = true
        
    }
    
    func configSearchTitleAuthorView() {
        
        
        searchStackView.axis = UILayoutConstraintAxis.vertical
        searchStackView.distribution = UIStackViewDistribution.fillEqually
        
        searchStackView.addArrangedSubview(secondSearchTitleBar)
        secondSearchTitleBar.placeholder = "Search Title"
        secondSearchTitleBar.tintColor = UIColor.themeOrange
        
        searchStackView.addArrangedSubview(searchAuthorBar)
        searchAuthorBar.placeholder = "Search Author"
        searchAuthorBar.tintColor = UIColor.themeOrange
        
        searchOptionsView.addSubview(searchStackView)
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.widthAnchor.constraint(equalTo: searchOptionsView.widthAnchor).isActive = true
        searchStackView.heightAnchor.constraint(equalTo: searchOptionsView.heightAnchor).isActive = true
        searchStackView.centerXAnchor.constraint(equalTo: searchOptionsView.centerXAnchor).isActive = true
        searchStackView.centerYAnchor.constraint(equalTo: searchOptionsView.centerYAnchor).isActive = true
        searchStackView.isHidden = true
        
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
        BookDataStore.shared.bookArray.removeAll()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addRatingAndComment" {
            let targetController = segue.destination as! AddCommentAndRatingViewController
            var synopsis = String()
            var author = String()
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let titleToPass = BookDataStore.shared.bookArray[indexPath.row].title
                guard let imageLinkToPass = BookDataStore.shared.bookArray[indexPath.row].finalBookCoverLink else {print("no image"); return}
                if let authorToPass = BookDataStore.shared.bookArray[indexPath.row].author {
                    author = authorToPass
                } else {
                    author = "no author available"
                }
                if let downloadedSynopsis = BookDataStore.shared.bookArray[indexPath.row].synopsis {
                    synopsis = downloadedSynopsis
                } else {
                    synopsis = "Synopsis not available"
                }
                targetController.passedTitle = titleToPass
                targetController.passedAuthor = author
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






