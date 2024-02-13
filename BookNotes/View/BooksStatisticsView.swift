//
//  BooksStatisticsView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 12/02/2024.
//

import Charts
import SwiftData
import SwiftUI

fileprivate struct BooksData: Identifiable {
	let id = UUID()
	let label: String
	let value: Int
}

struct BooksStatisticsView: View {
	@Query var books: [Book]
	
	
	var finishedBooksCount: Int {
		books.filter { $0.isFinished }.count
	}
	
	var unfinishedBooksCount: Int {
		books.filter { !$0.isFinished }.count
	}
	
	private var booksData: [BooksData] {
		[BooksData(label: "Finished", value: finishedBooksCount),
		 BooksData(label: "To read", value: unfinishedBooksCount)]
	}
	
	var body: some View {
		HStack {
			Text("You saved \(books.count) books")
				.font(.headline)
				.padding()
			
			Chart(booksData) { data in
				if data.value != 0 {
					SectorMark(angle: .value(Text(verbatim: data.label), data.value),
							   innerRadius: .ratio(0.6),
							   angularInset: 5
					)
					.annotation(position: .overlay) {
						Text(data.label)
							.padding(3)
							.background(.thinMaterial)
							.clipShape(.rect(cornerRadius: 5))
					}
					.foregroundStyle(by: .value(Text(verbatim: data.label), data.label))
				}
			}
			.chartLegend(.hidden)
			.padding()
		}
	}
}

#Preview {
	BooksStatisticsView()
}
