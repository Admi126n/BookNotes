//
//  URL+fetchData.swift
//  BookNotes
//
//  Created by Adam Tokarski on 19/01/2024.
//

import Foundation

extension URL {
	
	/// Fetches data from self URL
	/// - Parameter decoder: Custom JSONDecoder
	/// - Returns: Decoded data of given type fetched from self URL
	func fetchData<T: Codable>(using decoder: JSONDecoder = JSONDecoder()) async throws -> T {
		guard let (data, _) = try? await URLSession.shared.data(from: self) else {
			throw URLError(.badServerResponse)
		}
		
		guard let decodedData = try? decoder.decode(T.self, from: data) else {
			throw URLError(.badServerResponse)
		}
		
		return decodedData
	}
}
