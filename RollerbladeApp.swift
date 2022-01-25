//
//  RollerbladeApp.swift
//  Rollerblade
//
//  Created by Benjamin Who on 1/9/22.
//

import SwiftUI
import Purchases

@main
struct RollerbladeApp: App {
    
    init() {
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "appl_WpoqbOQkuACKGndpJwYIhjGSzEg")
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
        RootView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
    }
        
}

// isPresented: Binding.constant(true)
