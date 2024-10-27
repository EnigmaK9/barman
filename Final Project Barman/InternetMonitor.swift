// The Foundation and Network frameworks are imported.
// Foundation provides basic functionalities for apps, and Network is used to monitor network changes.
import Foundation
import Network

// The InternetMonitor class is created to monitor the device's internet connection status.
class InternetMonitor {

    // A shared static instance of InternetMonitor is declared.
    // This allows the class to be accessed globally using this shared instance.
    static let shared = InternetMonitor()

    // A private NWPathMonitor instance is declared.
    // NWPathMonitor monitors changes in the device’s network path.
    private var monitor: NWPathMonitor

    // A private dispatch queue is created with the label "InternetMonitorQueue".
    // The dispatch queue will be used to run the network monitor on a background thread.
    private var queue = DispatchQueue(label: "InternetMonitorQueue")

    // A public variable 'hasConnection' is declared and initialized to false.
    // It will store whether the device has an internet connection.
    var hasConnection: Bool = false

    // A public variable 'isConnectionWiFi' is declared and initialized to false.
    // It will store whether the current connection is using Wi-Fi.
    var isConnectionWiFi: Bool = false

    // The initializer is marked as private to ensure that this class cannot be instantiated outside of this file.
    private init() {
        // The NWPathMonitor instance is initialized to start monitoring network changes.
        monitor = NWPathMonitor()

        // A closure (pathUpdateHandler) is set to handle network changes.
        // 'self' is captured weakly to prevent memory leaks.
        monitor.pathUpdateHandler = { [weak self] path in
            // The status of the internet connection is checked.
            // If the connection is satisfied, 'hasConnection' is set to true.
            // Otherwise, 'hasConnection' is set to false.
            self?.hasConnection = path.status == .satisfied

            // It is checked whether the current connection is through Wi-Fi.
            // If the interface type is Wi-Fi, 'isConnectionWiFi' is set to true.
            self?.isConnectionWiFi = path.usesInterfaceType(.wifi)
        }

        // The monitor is started, and it begins observing network changes on the dispatch queue.
        monitor.start(queue: queue)
    }

    // The deinitializer is called when the InternetMonitor instance is deallocated.
    // The network monitor is stopped by calling cancel() to avoid unnecessary resource usage.
    deinit {
        monitor.cancel()
    }
}
