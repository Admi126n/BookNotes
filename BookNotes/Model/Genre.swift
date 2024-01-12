//
//  Genre.swift
//  BookNotes
//
//  Created by Adam Tokarski on 12/01/2024.
//

import Foundation

@frozen
enum Genre: String, CaseIterable, Codable {
	case adventure = "Adventure"
	case fantasy = "Fantasy"
	case history = "History"
	case horror = "Horror"
	case other = "Other"
	case romance = "Romance"
	case scienceFiction = "Science fiction"
	case selfDevelopement = "Self development"
	case thriller = "Thriller"
}
