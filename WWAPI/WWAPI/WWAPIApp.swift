//
//  WWAPIApp.swift
//  WWAPI
//
//  Created by Sara Sd on 03/02/1445 AH.
//

import SwiftUI

@main
struct WWAPIApp: App {
    let coreDataManager = CoreDataManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}



