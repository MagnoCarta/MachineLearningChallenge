//
//  MachineLearningApp.swift
//  Shared
//
//  Created by Gilberto Magno on 6/15/21.
//

import SwiftUI

@main
struct MachineLearningApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SoundView(generation: 0, dots: [])
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
