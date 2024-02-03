//
//  NetworkMonitor.swift
//  BookNotes
//
//  Created by Adam Tokarski on 30/01/2024.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
	@Published var isConnected = false
	
	private let networkMonitor = NWPathMonitor()
	private let workerQueue = DispatchQueue(label: "NetworkMonitor")
	
	init() {
		networkMonitor.pathUpdateHandler = { path in
			Task { @MainActor in
				self.isConnected = path.status == .satisfied
			}
		}
		networkMonitor.start(queue: workerQueue)
	}
}
