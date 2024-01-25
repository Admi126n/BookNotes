//
//  APIConnector.swift
//  BookNotes
//
//  Created by Adam Tokarski on 19/01/2024.
//

import Foundation

/// Struct describing books fetched from Google Books API.
///
/// Struct contains `title` and `authors` but rest od fields are oprional.
struct ApiBook: Hashable {
	private(set) var title: String
	private(set) var subtitle: String? = nil
	private(set) var authors: [String]
	private(set) var description: String? = nil
	private(set) var categories: [String]? = nil
	private(set) var averageRating: Float? = nil
	private(set) var imageLink: URL? = nil
	private(set) var price: Float? = nil
	private(set) var currency: String? = nil
		
	fileprivate init?(_ bookModel: BookModel) {
		guard let title = bookModel.volumeInfo.title, let authors = bookModel.volumeInfo.authors else {
			return nil
		}
		
		self.title = title
		self.subtitle = bookModel.volumeInfo.subtitle
		self.authors = authors
		self.description = bookModel.volumeInfo.description
		self.categories = bookModel.volumeInfo.categories
		self.averageRating = bookModel.volumeInfo.averageRating
		self.price = bookModel.saleInfo?.listPrice?.amount
		self.currency = bookModel.saleInfo?.listPrice?.currencyCode
		
		if let imageUrl = bookModel.volumeInfo.imageLinks?.thumbnail {
			self.imageLink = URL(string: imageUrl.replacingOccurrences(of: "http", with: "https"))
		}
	}
	
	static let example = ApiBook(
		BookModel(
			volumeInfo: VolumeInfo(
				title: "Example",
				subtitle: "Example book",
				authors: ["Unknown 1", "Unknown 2"],
				description: "Good example book",
				categories: ["Fantasy", "Adventure"],
				averageRating: 4.5,
				imageLinks: nil),
			saleInfo: SaleInfo(
				listPrice: ListPrice(
					amount: 40,
					currencyCode: "PLN"))))!
}

struct APIConnector {
	
	private static let base = "https://www.googleapis.com/books/v1/volumes"
	private static let type = "&printType=books"
	private static let limit = "&maxResults=10"
	
	private init() { }
	
	/// Parses given search text for Google Books API request.
	///
	/// Replaces all spaces with `%20` and trimms whitespacesAndNewlines
	/// - Parameter searchText: given search test
	/// - Returns: search text parsed to query format
	private static func parse(_ searchText: String) -> String {
		var parsed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		parsed = parsed.components(separatedBy: " ").filter { $0 != "" }.joined(separator: "%20")
		
		return parsed
	}
	
	/// Builds Google Books API URL request for given search text
	/// - Parameter searchText: given search text
	/// - Parameter requestType: Search request type
	/// - Returns: Google Books API URL request
	private static func buildURL(for searchText: String, _ requestType: RequestType) -> URL {
		let query = parse(searchText)
		
		switch requestType {
		case .author, .subject, .title:
			return URL(string: "\(base)?q=\(requestType.rawValue)\(query)\(type)\(limit)")!
		case .all, .defaultRequest:
			return URL(string: "\(base)?q=\(query)\(type)\(limit)")!
		}
	}
	
	/// Performs request to Google Books API.
	/// 
	/// If request fails returns nil.
	/// - Parameter query: Search text
	/// - Parameter requestType: Search request type
	/// - Returns: Fetched books data
	private static func performURLRequest(for query: String, _ requestType: RequestType) async -> [BookModel]? {
		let url = buildURL(for: query, requestType)
		
		do {
			let fetchedData: Items = try await url.fetchData()
			return fetchedData.items
		} catch {
			return nil
		}
	}
	
	/// Maps `[BookModel]` into `[ApiBook]`.
	///
	/// All given books which don't contain title and author are omitted.
	/// - Parameter books: Given books
	/// - Returns: Filtered books mapped into another struct
	private static func reduceFetched(_ books: [BookModel]) -> [ApiBook] {
		var result: [ApiBook] = []
		
		for book in books where book.volumeInfo.title != nil && book.volumeInfo.authors != nil {
			let newBook = ApiBook(book)!
			result.append(newBook)
		}
		
		return result.sorted { $0.title < $1.title }
	}
	
	/// Performs URL request and returns fetched data.
	/// - Parameter searchText: Given query for Google Books API
	/// - Parameter requestType: Search request type
	/// - Returns: Fetched data
	static func getApiResults(for searchText: String, _ requestType: RequestType = .defaultRequest) async -> [ApiBook] {
		var output: [BookModel] = []
		
		switch requestType {
		case .defaultRequest, .author, .subject, .title:
			guard let results = await performURLRequest(for: searchText, requestType) else {
				return []
			}
			
			output += results
		case .all:
			if let results = await performURLRequest(for: searchText, .author) {
				output += results
			}
			
			if let results = await performURLRequest(for: searchText, .subject) {
				output += results
			}
			
			if let results = await performURLRequest(for: searchText, .title) {
				output += results
			}
		}
		
		return reduceFetched(output)
	}
}

// MARK: - getter for tests

#if DEBUG
extension APIConnector {
	
	@available(*, deprecated, renamed: "parse", message: "method only for tests")
	static func testParse(_ searchText: String) -> String {
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
