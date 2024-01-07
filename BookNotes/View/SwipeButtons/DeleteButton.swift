//
//  DeleteButton.swift
//  BookNotes
//
//  Created by Adam Tokarski on 07/01/2024.
//

import SwiftUI

struct DeleteButton: View {
	let action: () -> Void
	
	var body: some View {
		Button("Delete", systemImage: "trash", action: action)
			.tint(.red)
	}
}

#Preview {
	DeleteButton() {
		print("Deleting...")
	}
}
