//
//  RatingView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 10/01/2024.
//

import SwiftUI

struct RatingView: View {
	@Binding var rating: Int
	
	private(set) var maxRating: Int
	
	private let offImage = Image(systemName: "star")
	private let onImage = Image(systemName: "star.fill")
	private let offColor = Color.gray
	private let onColor = Color.yellow
	
	var body: some View {
		HStack {
			ForEach(1..<maxRating + 1, id: \.self) { number in
				image(for: number)
					.foregroundStyle(number > rating ? offColor : onColor)
					.onTapGesture {
						withAnimation {
							rating = number
						}
					}
			}
		}
	}
	
	init(rating: Binding<Int>, maxRating: Int = 5) {
		self._rating = rating
		self.maxRating = maxRating
	}
	
	private func image(for number: Int) -> Image {
		number > rating ? offImage : onImage
	}
}

#Preview {
	RatingView(rating: .constant(4))
}
