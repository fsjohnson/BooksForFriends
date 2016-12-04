//
//  BooksReadCollectionViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 10/20/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class BooksUserWantsToReadCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var futureBooksArray = [String]()
    var bookIDArray = [String]()
    
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    var convertedImage: UIImage!
    var insetSpacing: CGFloat!
    var minimumInterItemSpacing: CGFloat!
    var minimumLineSpacing: CGFloat!
    
    
    var deleteButtonSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellConfig()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue

        PostsFirebaseMethods.downloadUsersFutureReadsBookLinkIDArray { (bookLinkArray, bookIDArray) in
            self.futureBooksArray = bookLinkArray
            self.bookIDArray = bookIDArray
            self.collectionView?.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PostsFirebaseMethods.downloadUsersFutureReadsBookLinkIDArray { (bookLinkArray, bookIDArray) in
            self.futureBooksArray = bookLinkArray
            self.bookIDArray = bookIDArray
            print("COUNT: \(self.futureBooksArray.count)")
            self.collectionView?.reloadData()
        }
        
        self.cellConfig()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return futureBooksArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! FutureReadsCollectionViewCell

        
        let imageLink = futureBooksArray[indexPath.item]
        let imageURL = URL(string: imageLink)
        guard let data = try? Data(contentsOf: imageURL!) else {
            cell.bookCoverImageView.image = UIImage(named: "BFFLogo")
            return cell
        }
        
        cell.bookCoverImageView.image = UIImage(data: data)
        
        return cell
    }
    
    
    //MARK: Cell Layout Configuration
    
    func cellConfig() {
        let screedWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let numOfRows = CGFloat(3.0)
        let numOfColumns = CGFloat(3.0)
        
        insetSpacing = 2
        minimumInterItemSpacing = 2
        minimumLineSpacing = 2
        sectionInsets = UIEdgeInsetsMake(insetSpacing, insetSpacing, insetSpacing, insetSpacing)
        referenceSize = CGSize(width: screedWidth, height: 0)
        
        let totalWidthDeduction = (minimumInterItemSpacing + minimumInterItemSpacing + sectionInsets.right + sectionInsets.left)
        let totalHeightDeduction = (sectionInsets.right + sectionInsets.left + minimumLineSpacing + minimumLineSpacing)
        
        itemSize = CGSize(width: (screedWidth/numOfColumns) - (totalWidthDeduction/numOfColumns), height: (screenHeight - totalHeightDeduction)/numOfRows)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    
    @IBAction func removeBook(_ sender: Any) {
        deleteButtonSelected = true
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)

        if deleteButtonSelected == true {
            let alert = UIAlertController(title: "Are you sure?", message: "Do you want to delete this book", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.deleteBook(at: indexPath)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func deleteBook(at indexPath: IndexPath) {
        
        let bookToRemove = bookIDArray[indexPath.item]
        
        PostsFirebaseMethods.removeBookFromFutureReadsWith(book: bookToRemove, completion: {
            let alert = UIAlertController(title: "Success!", message: "You have updated your reading list", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.futureBooksArray.remove(at: indexPath.row)
                self.deleteButtonSelected = false
                self.collectionView?.reloadData()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        })
    }
    
    
    
    
}
