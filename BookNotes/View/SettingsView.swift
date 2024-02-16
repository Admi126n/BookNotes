//
//  SettingsView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 11/02/2024.
//

import SwiftUI

@frozen
fileprivate enum SelectedLink {
	case savedCategories
}

struct SettingsView: View {
	var body: some View {
		NavigationStack {
			Form {
				Section("Settings") {
					NavigationLink(value: SelectedLink.savedCategories) {
						Text("Saved categories")
					}
				}
			}
			.navigationDestination(for: SelectedLink.self) { selection in
				switch selection {
				case .savedCategories:
					CategoriesListView()
				}
			}
		}
    }
}

#Preview {
    SettingsView()
}
