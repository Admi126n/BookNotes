//
//  CoverImage.swift
//  BookNotes
//
//  Created by Adam Tokarski on 28/01/2024.
//

import SwiftUI

struct CoverImage: View {
	private let image: Image
	
    var body: some View {
		image
			.border(.textEditorBackground, width: 4)
			.clipShape(.rect(cornerRadius: 5))
    }
	
	init(_ uiImage: UIImage) {
		self.image = Image(uiImage: uiImage)
	}
	
	init(_ image: Image) {
		self.image = image
	}
}

#Preview {
    CoverImage(Image(systemName: "book.closed"))
}
