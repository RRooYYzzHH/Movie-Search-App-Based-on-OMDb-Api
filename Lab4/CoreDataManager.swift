//
//  CoreDataManager.swift
//  Lab4
//
//  Created by RoYzH on 3/2/17.
//  Copyright © 2017 RoYzH. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func storeObj(title: String, poster: String, released: String, rated: String, score: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "MoviesEntity", in: context)
        
        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
        managedObj.setValue(title, forKey: "title")
        managedObj.setValue(poster, forKey: "poster")
        managedObj.setValue(released, forKey: "released")
        managedObj.setValue(rated, forKey: "rated")
        managedObj.setValue(score, forKey: "score")
        
        do {
            try context.save()
            print("Favoriate Movies Added: " + title)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    class func fetchObj() -> [Movies] {
        var array = [Movies]()
        
        let fetchRequest:NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                let movies = Movies(title: item.title!, poster: item.poster!, released: item.released!, rated: item.rated!, score: item.score!)
                array.append(movies)
            }
        } catch  {
            print(error.localizedDescription)
        }
        
        return array
    }
    
    class func cleanAllCoreData() {
        let fetchRequest:NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("Deleting all contents of core data..")
            try getContext().execute(deleteRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    class func deleteData(title: String) {
        let fetchRequest:NSFetchRequest<MoviesEntity> = MoviesEntity.fetchRequest()
        
        let predicate = NSPredicate(format: "title contains[c] %@", title)
        fetchRequest.predicate = predicate
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("Deleting favoriate movie \(title) from the core data..")
            try getContext().execute(deleteRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
}
