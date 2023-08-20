//
//  CoreDataManager.swift
//  WWAPI
//
//  Created by Sara Sd on 03/02/1445 AH.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    init() {
        
        self.container = NSPersistentContainer(name: "WeatherCoreData")
        container.loadPersistentStores { storeDescription, error in
            
        }
    }
}
