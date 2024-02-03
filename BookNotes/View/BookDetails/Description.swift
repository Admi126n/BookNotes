//
//  Description.swift
//  BookNotes
//
//  Created by Adam Tokarski on 01/02/2024.
//

import SwiftUI

struct Description: View {
	@State private var lineLimit: Int? = 3
	
	let text: String
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(text)
				.lineLimit(lineLimit)
			
			if lineLimit != nil {
				Text("Tap to expand")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		}
		.contentShape(.rect)
		.onTapGesture {
			withAnimation {
				if lineLimit == 3 {
					lineLimit = nil
				} else {
					lineLimit = 3
				}
			}
		}
	}
	
	init(_ text: String) {
		self.text = text
	}
}

#Preview {
    Description("Example desctiption")
}
