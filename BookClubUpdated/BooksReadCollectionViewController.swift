//
//  BooksReadCollectionViewController.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 10/20/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import UIKit

class BooksReadCollectionViewController: UICollectionViewController {

    
    var futureBooksArray = [String]()
    
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

        PostsFirebaseMethods.downloadUsersFutureReadsBookLinkIDArray { (bookLinkArray) in
            self.futureBooksArray = bookLinkArray
            print("COUNT: \(self.futureBooksArray.count)")
            self.collectionView?.reloadData()
        }
        
        self.cellConfig()
        
        self.collectionView!.register(FutureReadsCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")

        
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
        
        
        //HOW TO DO THIS USING setImageFromURl(stringImageUrl:)???
        
        let imageLink = futureBooksArray[indexPath.item]
        print("IMAGE LINK: \(imageLink)")
        let imageURL = URL(string: imageLink)
        let data = try? Data(contentsOf: imageURL!)
        cell.bookCoverImageView.image = UIImage(data: data!)
        
        
        
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
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    //        return referenceSize
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSize
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
