//
//  BookNotesApp.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

@main
struct BookNotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: Book.self)
    }
}
