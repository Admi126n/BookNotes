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
	var title: String
	var notes: String?
	var finished: Bool
	var readDate: Date?
	var rating: Int?
	
	init(title: String, author: String, genre: String, finished: Bool, readDate: Date? = nil, notes: String? = nil, rating: Int? = nil) {
		self.title = title
		self.author = author
		self.genre = genre
		self.finished = finished
		self.notes = notes
		
		if finished {
			self.readDate = readDate
			self.rating = rating
		}
	}
	
	static let example = Book(
		title: "Zen The Art Of Simple Living",
		author: "Shunmyo Masuno",
		genre: "philosophy",
		finished: true,
		readDate: .now,
		rating: 5
	)
}
