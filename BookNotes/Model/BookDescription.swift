//
//  BookDescription.swift
//  BookNotes
//
//  Created by Adam Tokarski on 28/01/2024.
//

import Foundation

protocol BookDescription {
	var authors: [String] { get }
	var categories: [String] { get }
	var title: String { get }
}
