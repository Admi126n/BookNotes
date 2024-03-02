//
//  AddToFavouritesButton.swift
//  BookNotes
//
//  Created by Adam Tokarski on 07/01/2024.
//

import SwiftUI

struct AddToFavouritesButton: View {
	let action: () -> Void
	
    var body: some View {
		Button("Add to favourites", systemImage: "heart.fill", action: action)
			.tint(.pink)
    }
}

#Preview {
	AddToFavouritesButton() {
		print("Adding to favourites...")
	}
}
