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
	let color: Color
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
		[BooksData(label: String(localized: "chart.finished"), value: finishedBooksCount, color: .green),
		 BooksData(label: String(localized: "chart.unfinished"), value: unfinishedBooksCount, color: .blue)]
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Books statistics")
				.font(.title2)
				.bold()
				.padding(.leading, 10)
			
			HStack {
				Text("You saved \(books.count) books")
					.font(.headline)
					.padding(.leading, 20)
				
				if !books.isEmpty {
					VStack {
						Chart(booksData) { data in
							if data.value != 0 {
								SectorMark(angle: .value(Text(verbatim: data.label), data.value),
										   innerRadius: .ratio(0.6),
										   angularInset: 5
								)
								.annotation(position: .overlay) {
									Text("\(data.value)")
										.padding(.vertical, 3)
										.padding(.horizontal, 8)
										.background(.thinMaterial)
										.clipShape(.rect(cornerRadius: 5))
								}
								.foregroundStyle(data.color)
							}
						}
						.chartLegend(.hidden)
						.padding()
						
						HStack(spacing: 3) {
							if booksData[1].value > 0 {
								Circle()
									.foregroundStyle(booksData[1].color)
									.frame(width: 10)
								
								Text("To read")
									.padding(.trailing, 10)
							}
							
							if booksData[0].value > 0 {
								Circle()
									.foregroundStyle(booksData[0].color)
									.frame(width: 10)
								
								Text("Finished")
							}
						}
						.font(.footnote)
					}
				}
			}
		}
	}
}

#Preview {
	BooksStatisticsView()
		.environmentObject(Favourites())
}
