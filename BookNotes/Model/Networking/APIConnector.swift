//
//  APIConnector.swift
//  BookNotes
//
//  Created by Adam Tokarski on 19/01/2024.
//

import Foundation

fileprivate struct Items: Codable {
	let items: [BookModel]
}

fileprivate struct BookModel: Codable {
	let volumeInfo: VolumeInfo
	let saleInfo: SaleInfo?
}

fileprivate struct VolumeInfo: Codable {
	let title: String
	let subtitle: String?
	let authors: [String]
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

struct APIConnector {
	func getData() async throws {
		let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=Clean%20Code&maxResults=1")!
		
		do {
			let fetchedData: Items = try await url.fetchData()
			
			for book in fetchedData.items {
				print(book.volumeInfo.title)
				print(book.volumeInfo.authors)
			}
		} catch {
			print("Cannot decode")
		}
	}
}
