//
//  RequestType.swift
//  BookNotes
//
//  Created by Adam Tokarski on 25/01/2024.
//

import Foundation

@frozen
enum RequestType: String {
	
	/// Search by author, title and subject (genre)
	case all
	
	/// Default Google Books API search request
	case defaultRequest
	
	/// Search by author
	case author = "inauthor:"
	
	/// Search by subject (genre)
	case subject = "subject:"
	
	/// Seach by title
	case title = "intitle:"
}
