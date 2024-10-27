// InternetMonitor.swift

import Foundation
import Network

class InternetMonitor {
    static let shared = InternetMonitor()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue(label: "InternetMonitorQueue")

    var hasConnection: Bool = false
    var isConnectionWiFi: Bool = false

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.hasConnection = path.status == .satisfied
            self?.isConnectionWiFi = path.usesInterfaceType(.wifi)
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
