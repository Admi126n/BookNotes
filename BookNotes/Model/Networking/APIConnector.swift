//
//  APIConnector.swift
//  BookNotes
//
//  Created by Adam Tokarski on 19/01/2024.
//

import Foundation

/// Struct describing books fetched from Google Books API.
///
/// Struct contains `title`, `authors` and `categories` but other fields are oprional.
struct APIBook: BookDescription, Hashable {
	private var amount: Float? = nil
	private(set) var authors: [String]
	private(set) var averageRating: Float? = nil
	private(set) var categories: [String]
	private var currency: String? = nil
	private(set) var description: String? = nil
	private(set) var imageLink: URL? = nil
	private(set) var subtitle: String? = nil
	private(set) var title: String
	
	var price: (amount: Float, currency: String)? {
		if let amount = self.amount, let currency = self.currency {
			return (amount: amount, currency: currency)
		} else {
			return nil
		}
	}
	
	fileprivate init?(_ bookModel: BookModel) {
		guard let title = bookModel.volumeInfo.title,
			  let authors = bookModel.volumeInfo.authors,
			  let categories = bookModel.volumeInfo.categories else {
			return nil
		}
		
		self.amount = bookModel.saleInfo?.listPrice?.amount
		self.authors = authors
		self.averageRating = bookModel.volumeInfo.averageRating
		self.categories = categories
		self.currency = bookModel.saleInfo?.listPrice?.currencyCode
		self.description = bookModel.volumeInfo.description
		self.subtitle = bookModel.volumeInfo.subtitle
		self.title = title
		
		if let imageUrl = bookModel.volumeInfo.imageLinks?.thumbnail {
			self.imageLink = URL(string: imageUrl.replacingOccurrences(of: "http", with: "https"))
		}
	}
	
	static let example = APIBook(
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
	
	/// Maps `[BookModel]` into `[APIBook]`.
	///
	/// All given books which don't contain title and author are omitted.
	/// - Parameter books: Given books
	/// - Returns: Filtered books mapped into another struct
	private static func reduceFetched(_ books: [BookModel]) -> [APIBook] {
		var output: [APIBook] = []
		
		for book in books where book.volumeInfo.title != nil 
			&& book.volumeInfo.authors != nil
			&& book.volumeInfo.categories != nil {
			let newBook = APIBook(book)!
			output.append(newBook)
		}
		
		return output.sorted { $0.title < $1.title }
	}
	
	/// Performs URL request and returns fetched data.
	/// - Parameter searchText: Given query for Google Books API
	/// - Parameter requestType: Search request type
	/// - Returns: Fetched data
	static func getApiResults(for searchText: String, _ requestType: RequestType = .all) async -> [APIBook] {
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
		
		// TODO: - filter results to avoid duplicates
		return reduceFetched(output)
	}
	
	/// Gets and returns image data from given link.
	/// - Parameter url: data url
	/// - Returns: fetched data
	static func getImageData(from url: URL) async -> Data? {
		if let (data, _) = try? await URLSession.shared.data(from: url) {
			return data
		} else {
			return nil
		}
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
