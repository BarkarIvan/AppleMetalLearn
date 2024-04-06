//
//  AppleMetalLearnApp.swift
//  AppleMetalLearn
//
//  Created by barkar on 06.04.2024.
//

import SwiftUI

@main
struct AppleMetalLearnApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
