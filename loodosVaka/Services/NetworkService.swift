//
//  NetworkService.swift
//  loodosVaka
//
//  Created by Erkut Ter on 18.06.2023.
//

import Foundation
import Network

class NetworkService: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
