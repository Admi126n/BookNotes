//
//  SettingsView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 11/02/2024.
//

import SwiftUI

struct SettingsView: View {
	var body: some View {
		NavigationStack {
			Form {
				
				Section("Settings") {
					NavigationLink {
						CategoriesListView()
					} label: {
						Text("Saved categories")
					}
				}
			}
		}
    }
}

#Preview {
    SettingsView()
}
