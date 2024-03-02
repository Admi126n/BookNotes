//
//  BookNotesApp.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI
import TipKit

@main
struct BookNotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.task {
					#if DEBUG
					try? Tips.resetDatastore()
					#endif
					
					try? Tips.configure([
						.displayFrequency(.immediate),
						.datastoreLocation(.applicationDefault)
					])
				}
        }
		.modelContainer(for: Book.self)
    }
}
