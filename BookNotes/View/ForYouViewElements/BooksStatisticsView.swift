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
	@EnvironmentObject var favourites: Favourites
	@Query var books: [Book]
	
	
	var finishedBooksCount: Int {
		books.filter { $0.isFinished }.count
	}
	
	var unfinishedBooksCount: Int {
		books.filter { !$0.isFinished }.count
	}
	
	// TODO: translate labels
	private var booksData: [BooksData] {
		[BooksData(label: String(localized: "chart.finished"), value: finishedBooksCount),
		 BooksData(label: String(localized: "chart.unfinished"), value: unfinishedBooksCount)]
	}
	
	private var favouritesText: Text {
		if favourites.count == 0 {
			Text("")
		} else {
			Text(" and \(favourites.count) are marked as favoutites!")
		}
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Books statistics")
				.font(.title2)
				.bold()
				.padding(.leading, 5)
			
			HStack {
				Group {
					Text("You saved \(books.count) books") + favouritesText
				}
				.font(.headline)
				.padding()
				
				if !books.isEmpty {
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
	}
}

#Preview {
	BooksStatisticsView()
		.environmentObject(Favourites())
}
