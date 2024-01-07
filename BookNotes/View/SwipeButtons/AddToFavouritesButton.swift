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
		Button("Add to favourites", systemImage: "star.fill", action: action)
			.tint(.yellow)
    }
}

#Preview {
	AddToFavouritesButton() {
		print("Adding to favourites...")
	}
}
