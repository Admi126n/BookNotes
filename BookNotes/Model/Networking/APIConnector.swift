//
//  APIConnector.swift
//  BookNotes
//
//  Created by Adam Tokarski on 19/01/2024.
//

import Foundation

struct ApiBook {
	let title: String
	let subtitle: String? = nil
	let authors: [String]
	let description: String? = nil
	let categories: [String]? = nil
	let averageRating: Float? = nil
	let imageLink: URL? = nil
	let price: Float? = nil
	let currency: String? = nil
	
	init(title: String, authors: [String]) {
		self.title = title
		self.authors = authors
	}
}

struct APIConnector {
	
	private let base = "https://www.googleapis.com/books/v1/volumes"
	private let type = "&printType=books"
	private let limit = "&maxResults=10"
	
	/// Parses given search text for Google Books API request.
	///
	/// Replaces all spaces with `%20` and trimms whitespacesAndNewlines
	/// - Parameter searchText: given search test
	/// - Returns: search text parsed to query format
	private func parse(_ searchText: String) -> String {
		var parsed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		parsed = parsed.components(separatedBy: " ").filter { $0 != "" }.joined(separator: "%20")
		
		return parsed
	}
	
	/// Builds Google Books API URL request for given search text
	/// - Parameter searchText: given search text
	/// - Returns: Google Books API URL request
	private func buildURL(for searchText: String) -> URL {
		let query = parse(searchText)
		
		return URL(string: "\(base)?q=\(query)\(type)\(limit)")!
	}
	
	private func getSearchResults() async -> [BookModel] {
		let url = buildURL(for: "Clean code")
		
		do {
			let fetchedData: Items = try await url.fetchData()
			return fetchedData.items
		} catch {
			print("Cannot decode")
			return []
		}
	}
	
	private func getFilteredBooks(_ decodedData: [BookModel]) -> [ApiBook] {
		var books: [ApiBook] = []
		
		for book in decodedData {
			if let title = book.volumeInfo.title, let authors = book.volumeInfo.authors {
				let newBook = ApiBook(title: title, authors: authors)
				books.append(newBook)
			}
		}
		
		return books
	}
}

// MARK: - getter for tests

#if DEBUG
extension APIConnector {
	
	@available(*, deprecated, renamed: "parse", message: "method only for tests")
	func testParse(_ searchText: String) -> String {
		parse(searchText)
	}
}
#endif

// MARK: - structs needed for decoding data

fileprivate struct Items: Codable {
	let items: [BookModel]
}

fileprivate struct BookModel: Codable {
	let volumeInfo: VolumeInfo
	let saleInfo: SaleInfo?
}

fileprivate struct VolumeInfo: Codable {
	let title: String?
	let subtitle: String?
	let authors: [String]?
	let description: String?
	let categories: [String]?
	let averageRating: Float?
	let imageLinks: ImageLink?
}

fileprivate struct ImageLink: Codable {
	let thumbnail: String?
}

fileprivate struct SaleInfo: Codable {
	let listPrice: ListPrice?
}

fileprivate struct ListPrice: Codable {
	let amount: Float?
	let currencyCode: String?
}
