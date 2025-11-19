//
//  ProductivityApp.swift
//  Productivity
//
//  Created by Student_User on 11/18/25.
//

import SwiftUI

@main
struct ProductivityApp: App {
    @StateObject private var themeManager = ThemeManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)  
        }
    }
}
