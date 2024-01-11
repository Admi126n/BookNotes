//
//  Book.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import Foundation
import SwiftData

@Model
class Book {
	var author: String
	var genre: String
	var title: String = ""
	var notes: String = ""
	private(set) var finished: Bool = false
	private(set) var readDate: Date?
	var rating: Int = 3
	
	/// Init for unfinished books
	init(title: String, author: String, genre: String) {
		self.title = title
		self.author = author
		self.genre = genre
	}
	
	/// Init for finished books
	init(title: String, author: String, genre: String, readDate: Date, notes: String = "", rating: Int = 1) {
		self.title = title
		self.author = author
		self.genre = genre
		self.finished = true
		self.notes = notes
		self.rating = rating
		self.readDate = readDate
	}
	
	func markAsFinished() {
		readDate = .now
		finished = true
	}
}
