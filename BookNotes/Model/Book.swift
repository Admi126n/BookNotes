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
			joinedAuthors = newValue.joined(separator: ", ")
		}
	}
	
	private(set) var categories: [String] {
		didSet {
			joinedCategories = newValue.joined(separator: ", ")
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
		self.title = title
		self.authors = authors.components(separatedBy: ", ")
		self.categories = categories.components(separatedBy: ", ")
	}
	
	/// Init for unfinished books
	/// - Parameters:
	///   - title: title
	///   - authors: list of authors
	///   - categories: list of categories
	init(title: String, authors: [String], categories: [String] = ["Other"]) {
		self.title = title
		self.authors = authors
		self.categories = categories
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
