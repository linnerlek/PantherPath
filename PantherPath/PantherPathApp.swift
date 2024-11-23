//
//  PantherPathApp.swift
//  PantherPath
//
//  Created by Linn on 11/22/24.
//

import SwiftUI
import CoreData

@main
struct GSHacksApp: App {
    
    // The persistent container is used to manage the Core Data stack
    let persistentContainer: NSPersistentContainer
    
    // The managed object context is used for interacting with Core Data
    let context: NSManagedObjectContext
    
    init() {
        // Initialize the persistent container and managed object context
        persistentContainer = NSPersistentContainer(name: "GSHacks") // Make sure this matches your .xcdatamodeld file name
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
        context = persistentContainer.viewContext
    }
    
    var body: some Scene {
        WindowGroup {
            // Inject the managed object context into the ContentView
            ContentView()
                .environment(\.managedObjectContext, context)
        }
    }
}
