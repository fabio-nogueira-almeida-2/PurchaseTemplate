import Foundation

protocol HasAnalytics {
    var analytics: AnalyticsProtocol { get }
}

protocol HasDispatchGroup {
    var dispatchGroup: DispatchGroup { get }
}

protocol AnalyticsProtocol {
    func track(event: String, properties: [String: Any]?)
}

class MockDependencies: HasAnalytics, HasDispatchGroup {
    let analytics: AnalyticsProtocol = MockAnalytics()
    let dispatchGroup = DispatchGroup()
}

class MockAnalytics: AnalyticsProtocol {
    func track(event: String, properties: [String: Any]?) {
        print("Analytics: \(event) - \(properties ?? [:])")
    }
}

