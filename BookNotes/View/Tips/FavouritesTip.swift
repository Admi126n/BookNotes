//
//  FavouritesTip.swift
//  BookNotes
//
//  Created by Adam Tokarski on 28/02/2024.
//

import SwiftUI
import TipKit

struct FavouritesTip: Tip {
	var title: Text {
		Text("Add some favourite books!")
	}
	
	var message: Text? {
		Text("When you add favourite books here will be some suggested books based on your preferences.")
	}
	
	var image: Image? {
		Image(systemName: "star.fill")
	}
}
