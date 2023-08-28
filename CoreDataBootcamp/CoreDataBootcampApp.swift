//
//  CoreDataBootcampApp.swift
//  CoreDataBootcamp
//
//  Created by Constantine Kulak on 28.08.2023.
//

import SwiftUI

@main
struct CoreDataBootcampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
