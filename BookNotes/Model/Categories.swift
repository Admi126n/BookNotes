//
//  Categories.swift
//  BookNotes
//
//  Created by Adam Tokarski on 06/02/2024.
//

import Foundation

class Categories: ObservableObject {
	private let saveKey = "Categories"
	private let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	
	private(set) var elements: Set<String> = []
	
	init() {
		if let data = try? Data(contentsOf: dataPath.appending(path: saveKey)) {
			if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
				elements = decoded
				return
			}
		}
		
		elements = []
	}
	
	func remove(_ category: String) {
		objectWillChange.send()
		elements.remove(category)
		save()
	}
	
	func remove(_ categories: [String]) {
		objectWillChange.send()
		elements.subtract(categories)
		save()
	}
	
	func add(_ category: String) {
		objectWillChange.send()
		elements.insert(category)
		save()
	}
	
	func add(_ categories: [String]) {
		objectWillChange.send()
		elements.formUnion(categories)
		save()
	}
	
	func save() {
		do {
			let encoded = try JSONEncoder().encode(elements)
			try encoded.write(to: dataPath.appending(path: saveKey), options: [.atomic])
		} catch {
			print(error.localizedDescription)
		}
	}
}

