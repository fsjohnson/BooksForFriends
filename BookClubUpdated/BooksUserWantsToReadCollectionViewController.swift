//
//  BooksReadCollectionViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 10/20/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit
import CoreData

class BooksUserWantsToReadCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var futureBooksArray = [BookPosted]()
    var coreDataBooks = [FutureRead]()
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    var convertedImage: UIImage!
    var insetSpacing: CGFloat!
    var minimumInterItemSpacing: CGFloat!
    var minimumLineSpacing: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellConfig()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        if Reachability.isConnectedToNetwork() == true {
            PostsFirebaseMethods.userFutureReadsBooks { (futureReads) in
                self.futureBooksArray = futureReads
                self.collectionView?.reloadData()
            }
        } else {
            BFFCoreData.sharedInstance.fetchFutureReads()
            self.coreDataBooks = BFFCoreData.sharedInstance.futureReads
            self.collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            PostsFirebaseMethods.userFutureReadsBooks { (futureReads) in
                self.futureBooksArray = futureReads
                self.collectionView?.reloadData()
            }
        } else {
            BFFCoreData.sharedInstance.fetchFutureReads()
            self.coreDataBooks = BFFCoreData.sharedInstance.futureReads
            self.collectionView?.reloadData()
        }
        
        self.cellConfig()
    }
    
    func saveFutureRead() {
           
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Reachability.isConnectedToNetwork() {
            return futureBooksArray.count
        } else {
            return coreDataBooks.count
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! FutureReadsCollectionViewCell
        var imageLink = String()
        
        if Reachability.isConnectedToNetwork() {
            imageLink = futureBooksArray[indexPath.item].imageLink
            print("LINK REACHABLE: \(imageLink)")
        } else {
            imageLink = coreDataBooks[indexPath.item].imageLink!
            print("LINK CORE DATA: \(imageLink)")
        }
        print("FINAL LINK: \(imageLink)")

        if imageLink == "" {
            cell.bookCoverImageView.image = UIImage(named: "BFFLogo")
        } else {
            cell.bookCoverImageView.loadImageUsingCacheWithURLString(urlString: imageLink)
        }

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "futureReadsDetails" {
            let dest = segue.destination as! FutureReadsDetailsViewController
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    let link = futureBooksArray[indexPath.item].imageLink
                    let id = futureBooksArray[indexPath.item].bookUniqueID
                    let title = futureBooksArray[indexPath.item].title
                    dest.passedImageLink = link
                    dest.passedUniqueID = id
                    dest.passedTitle = title
                }
            }
        }
    }
}
