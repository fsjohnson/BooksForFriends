//
//  AddBookViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 11/21/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchBookTitle: UITextField!
    
    var tableView = UITableView()
    let searchButton = UIButton()
    var bookResults = [Book]()
    var isbnImage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchBookResultsTableViewCell.self, forCellReuseIdentifier: "bookResult")
        tableView.rowHeight = 100
        
        
        //TableView
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.90).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        //Textfield
        
        
        searchBookTitle.translatesAutoresizingMaskIntoConstraints = false
        searchBookTitle.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        searchBookTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70).isActive = true
        searchBookTitle.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBookTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        searchBookTitle.layer.borderWidth = 2.0
        searchBookTitle.layer.borderColor = UIColor.black.cgColor
        
        
        //Search message button
        
        self.view.addSubview(searchButton)
        searchButton.layer.borderWidth = 2.0
        searchButton.layer.borderColor = UIColor.black.cgColor
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(UIColor.blue, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonFunc), for: .touchUpInside)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.30).isActive = true
        searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        
    }
    
    
    func searchButtonFunc(sender: UIButton!) {
        
        BookDataStore.shared.getBookResults(with: searchBookTitle.text!) { (results) in
            for result in results {
                
                if self.bookResults.count == 0 {
                    self.bookResults.append(result)
                } else {
                    for book in self.bookResults {
                        if book.title != result.title {
                            self.bookResults.append(result)
                            break
                        }
                    }
                }
                
            }
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
            
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookResult", for: indexPath) as! SearchBookResultsTableViewCell
        
        cell.titleLabel.text = "Title: "
        cell.authorLabel.text = "Author "
        
        cell.bookTitleLabel.text = bookResults[indexPath.row].title
        cell.bookAuthorLabel.text = bookResults[indexPath.row].author
        
        OperationQueue.main.addOperation {
            cell.bookImage.image = self.bookResults[indexPath.row].bookCover
        }
        
        return cell
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
