//
//  BooksReadCollectionViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 10/20/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class BooksUserWantsToReadCollectionViewController: UICollectionViewController {
    
    
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
        
        PostsFirebaseMethods.downloadUsersFutureReadsBookLinkIDArray { (bookLinkArray, bookIDArray) in
            self.futureBooksArray = bookLinkArray
            self.bookIDArray = bookIDArray
            print("COUNT: \(self.futureBooksArray.count)")
            self.collectionView?.reloadData()
        }
        
        self.cellConfig()
        
        self.collectionView!.register(FutureReadsCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        
        
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        collectionView?.allowsMultipleSelection = true
        
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
        // #warning Incomplete implementation, return the number of items
        return futureBooksArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! FutureReadsCollectionViewCell
        
        
        let imageLink = futureBooksArray[indexPath.item]
        print("IMAGE LINK: \(imageLink)")
        let imageURL = URL(string: imageLink)
        let data = try? Data(contentsOf: imageURL!)
        
        //        if data == nil {
        //            cell.bookCoverImageView.image = UIImage(named: "BFFLogo")
        //        } else {
        //            cell.bookCoverImageView.image = UIImage(data: data!)
        //        }
        
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    //MARK: Header & Footer Layout Configuration
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            // set up and return a view
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell", for: indexPath)
            
            headerView.backgroundColor = UIColor.gray
            
            return headerView
            
            
        }
        
        if kind == UICollectionElementKindSectionFooter {
            
            // set up and return a view
            
        }
        
        return UICollectionReusableView()
        
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
        referenceSize = CGSize(width: screedWidth, height: 80)
        
        let totalWidthDeduction = (minimumInterItemSpacing + minimumInterItemSpacing + sectionInsets.right + sectionInsets.left)
        let totalHeightDeduction = (sectionInsets.right + sectionInsets.left + minimumLineSpacing + minimumLineSpacing)
        
        
        
        itemSize = CGSize(width: (screedWidth/numOfColumns) - (totalWidthDeduction/numOfColumns), height: (screenHeight - totalHeightDeduction)/3)
        
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
    
    
    @IBAction func removeBookFromFutureReadsButton(_ sender: Any) {
        
        deleteButtonSelected = true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        let bookToRemove = bookIDArray[indexPath.item]
        
        if deleteButtonSelected == true {
            
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.gray.cgColor
            
            PostsFirebaseMethods.removeBookFromFutureReadsWith(book: bookToRemove, completion: {
                let alert = UIAlertController(title: "Success!", message: "You have updated your reading list", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }))
                
                self.deleteButtonSelected = false
                self.collectionView?.reloadData()
                
            })
            
        }
        
        
    }
    
}
