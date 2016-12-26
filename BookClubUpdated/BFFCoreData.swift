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
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: BFFCoreData.sharedInstance.name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
    
    func fetchData() {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        do {
            self.posts = try managedContext.fetch(fetchRequest)
        } catch {}
    }
    
    func deleteData() {
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
                    print("ID VS UNIQUE KEY: \(followingID) vs. \(object.userUniqueKey)")
                    context.delete(object)
                    try context.save()
                }
            }
        } catch {}
    }
}
