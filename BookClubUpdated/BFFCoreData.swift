//
//  BookClubUpdated.swift
//  BookClubUpdated
//
//  Created by Felicity Johnson on 12/23/16.
//  Copyright © 2016 FJ. All rights reserved.
//

import Foundation
import CoreData

class BFFCoreData {
    
    static let sharedInstance = BFFCoreData()
    private let name = "BFFCoreData"
    var posts = [Post]()
    var futureReads = [FutureRead]()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: BFFCoreData.sharedInstance.name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Posts Core Data
    
    func fetchPostsData() {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        do {
            self.posts = try managedContext.fetch(fetchRequest)
        } catch {}
    }
    
    func deletePostsData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        do {
            self.posts = try context.fetch(fetchRequest)
            for object in posts {
                context.delete(object)
                try context.save()
            }
        } catch {}
    }
    
    func deleteFollowingData(with followingID: String) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        do {
            self.posts = try context.fetch(fetchRequest)
            for object in posts {
                if followingID == object.userUniqueKey {
                    context.delete(object)
                    try context.save()
                }
            }
        } catch {}
    }
    
    func fetchFutureReads() {
        let context = persistentContainer.viewContext
        let fetch = NSFetchRequest<FutureRead>(entityName: "FutureRead")
        do {
            self.futureReads = try context.fetch(fetch)
        } catch {}
    }
}
