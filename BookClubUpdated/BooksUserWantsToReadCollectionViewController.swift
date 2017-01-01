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
    var futureRead: FutureRead!
    var noFutureReadsView: NoFutureReadsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellConfig()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange
        self.tabBarController?.tabBar.barTintColor = UIColor.themeDarkBlue
        
        let navBarAttributesDictionary = [ NSForegroundColorAttributeName: UIColor.themeDarkBlue,NSFontAttributeName: UIFont.themeMediumThin]
        navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        guard let navBarHeight = self.navigationController?.navigationBar.frame.height else { print("no nav bar height"); return }
        
        self.noFutureReadsView = NoFutureReadsView(frame: CGRect(x: 0, y: -navBarHeight, width: self.view.frame.width, height: self.view.frame.height))
        
        configData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Reachability.isConnectedToNetwork() == true {
            BFFCoreData.sharedInstance.deleteFutureReads()
            PostsFirebaseMethods.userFutureReadsBooks { (futureReads, success) in
                if success == false {
                    self.view.addSubview(self.noFutureReadsView)
                } else {
                    self.futureBooksArray = futureReads
                    self.collectionView?.reloadData()
                }
            }
        } else {
            BFFCoreData.sharedInstance.fetchFutureReads()
            self.view.addSubview(self.noFutureReadsView)
            self.coreDataBooks = BFFCoreData.sharedInstance.futureReads
            if self.coreDataBooks.count > 0 {
                self.noFutureReadsView.removeFromSuperview()
                self.collectionView?.reloadData()
            }
        }
        self.cellConfig()
    }
    
    func configData() {
        if Reachability.isConnectedToNetwork() == true {
            BFFCoreData.sharedInstance.deleteFutureReads()
            PostsFirebaseMethods.userFutureReadsBooks { (futureReads, success) in
                if success == false {
                    self.view.addSubview(self.noFutureReadsView)
                } else {
                    self.futureBooksArray = futureReads
                    self.savePostsData(with: futureReads)
                    self.collectionView?.reloadData()
                }
            }
        } else {
            BFFCoreData.sharedInstance.fetchFutureReads()
            self.view.addSubview(self.noFutureReadsView)
            self.coreDataBooks = BFFCoreData.sharedInstance.futureReads
            if self.coreDataBooks.count > 0 {
                self.noFutureReadsView.removeFromSuperview()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func savePostsData(with futureReadsArray: [BookPosted]) {
        let managedContext = BFFCoreData.sharedInstance.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FutureRead", in: managedContext)
        if let unwrappedEntity = entity {
            for item in futureReadsArray {
                PostsFirebaseMethods.downloadSynopsisAndAuthorOfBookWith(book: item.bookUniqueID, completion: { (synopsis, author) in
                    let newRead = NSManagedObject(entity: unwrappedEntity, insertInto: managedContext) as! FutureRead
                    let newPost = Post(context: managedContext)
                    newRead.title = item.title
                    newRead.bookUniqueID = item.bookUniqueID
                    newRead.imageLink = item.imageLink
                    newRead.synopsis = synopsis
                    newRead.author = author
                    newRead.addToPost(newPost)
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
