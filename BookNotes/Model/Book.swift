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
	var genre: Genre
	var title: String = ""
	var notes: String = ""
	private(set) var isFinished: Bool = false
	private(set) var finishDate: Date?
	var rating: Int = 3
	
	/// Init for unfinished books
	init(title: String, author: String, genre: Genre) {
		self.title = title
		self.author = author
		self.genre = genre
	}
	
	/// Init for finished books
	init(title: String, author: String, genre: Genre, readDate: Date, notes: String = "", rating: Int = 1) {
		self.title = title
		self.author = author
		self.genre = genre
		self.isFinished = true
		self.notes = notes
		self.rating = rating
		self.finishDate = readDate
	}
	
	func markAsFinished() {
		finishDate = .now
		isFinished = true
	}
}
