// InternetMonitor.swift
//
//  InternetMonitor.swift
//  RemoteData
//
//  Created by Carlos Ignacio Padilla Herrera on 26/10/24.
//

import Foundation
import Network

class InternetMonitor {
    // It should be decided whether this should be a singleton
    var hasConnection = false
    var isConnectionWiFi = false
    private var monitor = NWPathMonitor()

    init() {
       // Actions to perform when the connection status changes...
       monitor.pathUpdateHandler = { path in
           self.hasConnection = path.status == .satisfied
           self.isConnectionWiFi = path.usesInterfaceType(.wifi)
       }
       // To start monitoring for changes...
       // Processes that may take a long time or many resources must be sent to the background
       monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}
