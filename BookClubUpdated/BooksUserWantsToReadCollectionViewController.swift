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
    var futureReads: FutureRead!
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellConfig()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        
        if Reachability.isConnectedToNetwork() == true {
            BFFCoreData.sharedInstance.deleteFutureReads()
            PostsFirebaseMethods.userFutureReadsBooks { (futureReads) in
                self.futureBooksArray = futureReads
                self.savePostsData(with: futureReads)
                print("FUTURE: \(self.futureBooksArray.count)")
                self.collectionView?.reloadData()
            }
        } else {
            BFFCoreData.sharedInstance.fetchFutureReads()
            self.coreDataBooks = BFFCoreData.sharedInstance.futureReads
            print("COUNT OF FUTURE: \(BFFCoreData.sharedInstance.futureReads.count)")
            self.collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            BFFCoreData.sharedInstance.deleteFutureReads()
            PostsFirebaseMethods.userFutureReadsBooks { (futureReads) in
                print("FUTURE: \(self.futureBooksArray.count)")
                self.futureBooksArray = futureReads
                self.collectionView?.reloadData()
            }
        } else {
            BFFCoreData.sharedInstance.fetchFutureReads()
            self.coreDataBooks = BFFCoreData.sharedInstance.futureReads
            print("COUNT OF FUTURE: \(BFFCoreData.sharedInstance.futureReads.count)")
            self.collectionView?.reloadData()
        }
        
        self.cellConfig()
    }
    
    func savePostsData(with futureReadsArray: [BookPosted]) {
        let managedContext = BFFCoreData.sharedInstance.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FutureRead", in: managedContext)
        
        if let unwrappedEntity = entity {
            for item in futureReadsArray {
                PostsFirebaseMethods.downloadSynopsisAndAuthorOfBookWith(book: item.bookUniqueID, completion: { (synopsis, author) in
                    let newRead = NSManagedObject(entity: unwrappedEntity, insertInto: managedContext) as! FutureRead
                    newRead.title = item.title
                    newRead.bookUniqueID = item.bookUniqueID
                    newRead.imageLink = item.imageLink
                    newRead.synopsis = synopsis
                    newRead.author = author
                    newRead.post = Post(context: managedContext)
//                    newRead.bookTitle = item.title
//                    newRead.imageLink = item.imageLink
//                    newRead.bookUniqueID = item.bookUniqueID
//                    newRead.author = author
//                    newRead.synopsis = synopsis
//                    newRead.bookUniqueID = item.bookUniqueID
//                    newRead.comment = item.comment
//                    newRead.rating = Float(item.rating)!
//                    newRead.userName = "no username"
//                    newRead.reviewID = item.reviewID
//                    newRead.timestamp = item.timestamp
//                    newRead.userUniqueKey = item.userUniqueKey
//                    print(newRead.bookTitle)
//                    print(newRead.imageLink)
//                    print(newRead.author)
//                    print(newRead.synopsis)
//                    print(newRead.bookUniqueID)
//                    print(newRead.comment)
//                    print(newRead.rating)
//                    print(newRead.userName)
//                    print(newRead.reviewID)
//                    print(newRead.timestamp)
//                    print(newRead.userUniqueKey)
                    print(newRead)
                    BFFCoreData.sharedInstance.saveContext()
                })
            }
        }
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
        } else {
            imageLink = coreDataBooks[indexPath.item].imageLink!
        }
        
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
