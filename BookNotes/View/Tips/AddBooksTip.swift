//
//  AddBooksTip.swift
//  BookNotes
//
//  Created by Adam Tokarski on 28/02/2024.
//

import SwiftUI
import TipKit

struct AddBooksTip: Tip {
	var title: Text {
		Text("Add some books!")
	}
	
	var message: Text? {
		Text(
		"""
		Press \(Image(systemName: "plus")) to add some books. Then you can *swipe them \
		left* to mark them as favourite or *swipe them right* to delete them.
		"""
		)
	}
	
	var image: Image? {
		Image(systemName: "text.book.closed")
	}
}
