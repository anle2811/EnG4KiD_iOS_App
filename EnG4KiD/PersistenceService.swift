//
//  PersistanceService.swift
//  EnG4KiD
//
//  Created by MacPro An Lê on 3/18/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import Foundation
import CoreData
class PersistenceService {
    
    private init(){}
    
    static var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataEng4Kid")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("It was successfully")
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}
