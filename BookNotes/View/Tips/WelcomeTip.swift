//
//  WelcomeTip.swift
//  BookNotes
//
//  Created by Adam Tokarski on 28/02/2024.
//

import SwiftUI
import TipKit

struct WelcomeTip: Tip {
	var title: Text {
		Text("Welcome in BooksNotes!")
	}
	
	var message: Text? {
		Text("You can go to *Search* or *To read* tab and add some books.")
	}
	
	var image: Image? {
		Image(systemName: "text.book.closed")
	}
}
