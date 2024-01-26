//
//  BookNotesTests.swift
//  BookNotesTests
//
//  Created by Adam Tokarski on 21/01/2024.
//

@testable import BookNotes
import XCTest

final class BookNotesTests: XCTestCase {

	func testApiConnectorParseSearchText_WhenInputWithSpaceGiven_ShouldReplaceSpace() {
		let searchText = "Clean code"
		
		let parsedInput = APIConnector.testParse(searchText)
		
		XCTAssertEqual(parsedInput, "Clean%20code")
	}

	func testApiConnectorParseSearchText_WhenInputWithMultipleSpaceGiven_ShouldReplaceSpace() {
		let searchText = "Clean   code"
		
		let parsedInput = APIConnector.testParse(searchText)
		
		XCTAssertEqual(parsedInput, "Clean%20code")
	}
}
