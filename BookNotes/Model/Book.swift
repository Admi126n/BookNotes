//
//  Book.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import Foundation
import SwiftData

@Model
class Book: BookDescription {
	// MARK: - Properties
	
	private(set) var authors: [String] {
		didSet {
			joinedAuthors = authors.joined(separator: ", ")
		}
	}
	
	private(set) var categories: [String] {
		didSet {
			joinedCategories = categories.joined(separator: ", ")
		}
	}
	
	var notes: String = ""
	var rating: Int = 3
	var title: String
	
	private(set) var finishDate: Date?
	private(set) var imageData: Data?
	private(set) var isFinished: Bool = false
	
	/// Property used in query predicate
	private(set) var joinedAuthors: String = ""
	
	/// Property used in query predicate
	private(set) var joinedCategories: String = ""
	
	// MARK: - Inits
	
	/// Init for unfinished books
	/// - Parameters:
	///   - title: title
	///   - authors: comma separated authors
	///   - categories: comma separated categories
	init(title: String, authors: String, categories: String = "Other") {
		self.title = title.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
		self.authors = authors.components(separatedBy: ", ").map {
			$0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		self.categories = categories.components(separatedBy: ", ").map {
			$0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		
		self.joinedAuthors = self.authors.joined(separator: ", ")
		self.joinedCategories = self.categories.joined(separator: ", ")
	}
	
	/// Init for unfinished books
	/// - Parameters:
	///   - title: title
	///   - authors: list of authors
	///   - categories: list of categories
	init(title: String, authors: [String], categories: [String] = ["Other"]) {
		self.title = title.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
		self.authors = authors.map { $0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines) }
		self.categories = categories
		
		self.joinedAuthors = self.authors.joined(separator: ", ")
		self.joinedCategories = self.categories.joined(separator: ", ")
	}
	
	// MARK: - Methods
	
	func markAsFinished() {
		finishDate = .now
		isFinished = true
	}
	
	func containsInTitle(_ text: String) -> Bool {
		title.localizedCaseInsensitiveContains(text)
	}
	
	func containsInAuthors(_ text: String) -> Bool {
		authors.joined().localizedCaseInsensitiveContains(text)
	}
	
	func containsInCategories(_ text: String) -> Bool {
		categories.joined().localizedCaseInsensitiveContains(text)
	}
	
	// MARK: - Setters
	
	func setCategories(_ categories: String) {
		self.categories = categories.components(separatedBy: ", ").sorted()
	}
	
	func setCategoreis(_ categories: [String]) {
		self.categories = categories.sorted()
	}
	
	func setImageData(_ data: Data) {
		self.imageData = data
	}
}

// MARK: - Equatable protocol

extension Book: Equatable {
	static func ==(_ lhs: Book, _ rhs: Book) -> Bool {
		lhs.authors == rhs.authors && lhs.title == rhs.title
	}
}
