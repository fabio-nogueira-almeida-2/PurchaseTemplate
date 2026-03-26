//
//  MockDependencyContainer.swift
//  PurchaseTemplate
//
//  Mock dependency container for testing
//

import Foundation
import UIKit
import SwiftUI

final class DependencyContainer: HasAnalytics, HasFeatureManager, HasDeeplinkOpener, HasWebViewFactory, HasNavigationManager, HasConsumerManager, HasAuth, ModuleDependencies {
    var analytics: AnalyticsProtocol {
        MockAnalytics()
    }
    
    var featureManager: FeatureManagerProtocol {
        MockFeatureManager()
    }
    
    var deeplinkOpener: DeeplinkOpenerProtocol {
        MockDeeplinkOpener()
    }
    
    var webView: WebViewFactoryProtocol {
        MockWebViewFactory()
    }
    
    var navigationManager: NavigationManagerProtocol {
        MockNavigationManager()
    }
    
    var consumerManager: ConsumerManagerProtocol {
        MockConsumerManager()
    }
    
    var auth: AuthProtocol {
        MockAuth()
    }
    
    var coreService: CoreServicing {
        MockCoreService.shared
    }
}

final class MockNavigationManager: NavigationManagerProtocol {
    private weak var currentNavigationController: UINavigationController?
    
    func setNavigationController(_ navigationController: UINavigationController?) {
        self.currentNavigationController = navigationController
    }
    
    func getCurrentNavigation() -> UINavigationController? {
        // Try to get from stored reference first
        if let nav = currentNavigationController {
            return nav
        }
        
        // Fallback: try to get from window hierarchy
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            if let nav = rootVC as? UINavigationController {
                return nav
            } else if let nav = rootVC.navigationController {
                return nav
            }
        }
        
        return nil
    }
}

// MARK: - Mock Implementations

final class MockAnalytics: AnalyticsProtocol {
    func log(_ event: AnalyticsEventProtocol) {
        print("📊 Analytics: \(event.name) - \(event.properties)")
    }
}

final class MockFeatureManager: FeatureManagerProtocol {
    func value(for key: FeatureFlagKey) -> Bool? {
        // Return false by default, can be configured for testing
        return false
    }
}

final class MockDeeplinkOpener: DeeplinkOpenerProtocol {
    private weak var currentNavigationController: UINavigationController?
    
    func setNavigationController(_ navigationController: UINavigationController?) {
        self.currentNavigationController = navigationController
        print("🔗 MockDeeplinkOpener: Navigation controller set: \(navigationController != nil ? "YES" : "NO")")
    }
    
    func open(url: URL) {
        print("🔗 Opening deeplink: \(url)")
        print("   - Scheme: \(url.scheme ?? "nil")")
        print("   - Path: \(url.path)")
        print("   - Query: \(url.query ?? "nil")")
        
        // Get navigation controller - try multiple sources
        var navigationController: UINavigationController?
        
        // First, try the stored reference
        if let navController = currentNavigationController {
            navigationController = navController
            print("✅ Using stored navigation controller")
        } else {
            // Try to get from the current window hierarchy
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootVC = window.rootViewController {
                
                // If root is NavigationController, use it
                if let navController = rootVC as? UINavigationController {
                    navigationController = navController
                    print("✅ Found navigation controller from root")
                }
                // If root is NavigationView wrapper, find the navigation controller
                else if let hostingController = rootVC as? UIHostingController<AnyView> {
                    // For SwiftUI NavigationView, we need to traverse
                    if let presentedVC = hostingController.presentedViewController as? UINavigationController {
                        navigationController = presentedVC
                        print("✅ Found navigation controller from presented")
                    }
                }
                // Try to find navigation controller in the hierarchy
                else {
                    navigationController = findNavigationController(in: rootVC)
                    if navigationController != nil {
                        print("✅ Found navigation controller in hierarchy")
                    }
                }
            }
        }
        
        guard let navController = navigationController else {
            print("⚠️ No navigation controller available - cannot navigate")
            print("   Current navigation controller reference: \(currentNavigationController != nil ? "set" : "nil")")
            return
        }
        
        // Handle purchase/offers deeplink - navigate to OffersList screen
        // Check both the full URL string, host, and path
        let fullURLString = url.absoluteString.lowercased()
        let path = url.path.lowercased()
        let host = url.host?.lowercased() ?? ""
        
        // Check if this is a purchase/offers or purchase/list deeplink
        // The URL can be: purchasetemplate://purchase/offers (host=purchase, path=/offers)
        // or: purchasetemplate://purchase/offers?query (host=purchase, path=/offers)
        let isPurchaseOffers = (fullURLString.contains("/purchase/offers") || fullURLString.contains("/purchase/list") || 
                                (host == "purchase" && (path == "/offers" || path == "/list" || path.contains("/offers") || path.contains("/list"))))
        
        if url.scheme == DeeplinkConfig.scheme && isPurchaseOffers {
            // Extract productId and productTypeId from query parameters
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let productId = components?.queryItems?.first(where: { $0.name == "productId" })?.value ?? "1"
            let productTypeId = components?.queryItems?.first(where: { $0.name == "productTypeId" })?.value ?? "1"
            
            print("📱 Navigating to OffersList with productId: \(productId), productTypeId: \(productTypeId)")
            
            // Create and push OffersList view controller
            let offersListVC = PurchaseListFactory.make(productId: productId, productTypeId: productTypeId)
            
            // Update navigation controller reference for the new screen
            DispatchQueue.main.async {
                navController.pushViewController(offersListVC, animated: true)
                // Update reference after push
                self.setNavigationController(navController)
            }
            return
        }
        
        // Handle purchase/offer detail deeplink - navigate to Detail screen
        // Check both the full URL string, host, and path
        let isPurchaseOfferDetail = (fullURLString.contains("/purchase/offer") || 
                                     (host == "purchase" && path.contains("/offer")))
        
        if url.scheme == DeeplinkConfig.scheme && isPurchaseOfferDetail {
            // Extract productId and offerId from path or query
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var productId = "1"
            var offerId = "1"
            var productTypeId = "1" // Default to Investment Funds
            
            // Try query parameters first
            if let pid = components?.queryItems?.first(where: { $0.name == "productId" })?.value {
                productId = pid
            }
            if let oid = components?.queryItems?.first(where: { $0.name == "offerId" })?.value {
                offerId = oid
            }
            if let ptid = components?.queryItems?.first(where: { $0.name == "productTypeId" })?.value {
                productTypeId = ptid
            } else {
                // Fallback: infer productTypeId from productId (if productId is "2", likely royalties)
                productTypeId = productId
            }
            
            // Fallback: try to parse from path
            if productId == "1" || offerId == "1" {
                let pathComponents = url.path.components(separatedBy: "/")
                if let offerIndex = pathComponents.firstIndex(where: { $0.lowercased() == "offer" }),
                   offerIndex + 2 < pathComponents.count {
                    productId = pathComponents[offerIndex + 1]
                    offerId = pathComponents[offerIndex + 2]
                }
            }
            
            print("📱 Navigating to Detail with offerId: \(offerId), productId: \(productId), productTypeId: \(productTypeId)")
            
            // Store productTypeId for this productId:offerId combination
            let key = "\(productId):\(offerId)"
            MockCoreService.shared.setProductTypeId(productTypeId, for: key)
            
            // Create and push Detail view controller
            let detailVC = PurchaseDetailFactory.make(offerId: offerId, productId: productId, productTypeId: productTypeId)
            
            DispatchQueue.main.async {
                navController.pushViewController(detailVC, animated: true)
                // Update reference after push
                self.setNavigationController(navController)
            }
            return
        }
        
        // For other deeplinks, try to open with UIApplication
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("⚠️ Cannot open deeplink: \(url)")
            print("   Scheme: \(url.scheme ?? "nil")")
            print("   Full URL: \(url.absoluteString)")
            print("   Path: \(url.path)")
            print("   Host: \(url.host ?? "nil")")
        }
    }
    
    private func findNavigationController(in viewController: UIViewController) -> UINavigationController? {
        if let navController = viewController as? UINavigationController {
            return navController
        }
        
        for child in viewController.children {
            if let navController = findNavigationController(in: child) {
                return navController
            }
        }
        
        if let presented = viewController.presentedViewController {
            return findNavigationController(in: presented)
        }
        
        return nil
    }
}

final class MockWebViewFactory: WebViewFactoryProtocol {
    func make(with url: URL, properties: WebViewProperties, completion: @escaping (Bool) -> Void) -> UIViewController {
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(URLRequest(url: url))
        webViewController.view.addSubview(webView)
        completion(true)
        return webViewController
    }
}

final class MockCoreService: CoreServicing {
    // Shared instance for storing productTypeId mapping
    static let shared = MockCoreService()
    
    // Store productTypeId mapping for detail endpoints
    private var productTypeIdMap: [String: String] = [:] // Key: "productId:offerId", Value: productTypeId
    
    func setProductTypeId(_ productTypeId: String, for key: String) {
        productTypeIdMap[key] = productTypeId
    }
    
    func getProductTypeId(for key: String) -> String? {
        return productTypeIdMap[key]
    }
    
    private init() {}
    
    func request<T: Decodable>(
        endpoint: InvestmentsEndpoint,
        decoder: JSONDecoder,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask? {
        // Mock implementation - returns mock data from fixtures
        print("🌐 Mock API Request: \(endpoint.path)")
        
        // Handle purchaseOrder endpoint - MUST come first (most specific)
        // Path format: invest/investplace/v1/products/{productId}/orders/offers/{offerId}/buy
        if endpoint.path.contains("/orders/offers/") && endpoint.path.contains("/buy") {
            var productId = "1"
            var offerId = "1"
            
            // Try to extract from endpoint enum case
            if case .purchaseOrder(_, let pid, let oid, _) = endpoint {
                productId = pid
                offerId = oid
            } else {
                // Fallback: try to parse from path
                let pathComponents = endpoint.path.components(separatedBy: "/")
                if let productsIndex = pathComponents.firstIndex(of: "products"),
                   productsIndex + 1 < pathComponents.count {
                    productId = pathComponents[productsIndex + 1]
                }
                if let offersIndex = pathComponents.firstIndex(of: "offers"),
                   offersIndex + 1 < pathComponents.count {
                    offerId = pathComponents[offersIndex + 1]
                }
            }
            
            // Return mock Data for purchase order
            let mockData = """
            {
                "success": true,
                "orderId": "\(offerId)",
                "productId": "\(productId)"
            }
            """.data(using: .utf8) ?? Data()
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("✅ Mock service returning success for purchase order offer \(offerId)")
                // Special handling for Data type
                if T.self == Data.self {
                    completion(.success(mockData as! T))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got Data")
                    completion(.failure(ApiError.decodingError))
                }
            }
        } else if case .purchaseCatalog = endpoint {
            // Handle purchaseCatalog endpoint - shows ALL investments
            // This MUST be checked before the generic "offers" check
            let mockResponse = PurchaseCatalogFixture.mockResponse()
            print("🌐 Mock API Request: \(endpoint.path)")
            print("✅ Mock service returning catalog with \(mockResponse.data.count) investments")
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let response = mockResponse as? T {
                    completion(.success(response))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got \(type(of: mockResponse))")
                    completion(.failure(ApiError.decodingError))
                }
            }
            return nil
        } else if endpoint.path.contains("welcome") {
            // Extract productId and productTypeId from endpoint
            var productId = "1"
            var productTypeId = "1"
            
            // Try to extract from endpoint enum case
            if case .purchaseWelcome(let pid, let ptid) = endpoint {
                productId = pid
                productTypeId = ptid
            } else {
                // Fallback: try to parse from path
                let pathComponents = endpoint.path.components(separatedBy: "/")
                if let productIdIndex = pathComponents.firstIndex(of: "products"),
                   productIdIndex + 1 < pathComponents.count {
                    productId = pathComponents[productIdIndex + 1]
                }
                if let typeIndex = pathComponents.firstIndex(of: "type"),
                   typeIndex + 1 < pathComponents.count {
                    productTypeId = pathComponents[typeIndex + 1]
                }
            }
            
            // Get mock data from fixture
            let mockResponse = PurchaseWelcomeFixture.mockResponseForProduct(
                productId: productId,
                productTypeId: productTypeId
            )
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("✅ Mock service returning success with \(mockResponse.data.items.count) items")
                if let response = mockResponse as? T {
                    completion(.success(response))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got \(type(of: mockResponse))")
                    completion(.failure(ApiError.decodingError))
                }
            }
        } else if endpoint.path.contains("/rules") && endpoint.path.contains("/offers/") {
            // Handle purchaseOrderRule endpoint - MUST come before detail check
            // Path format: invest/investplace/v1/products/{productId}/offers/{offerId}/rules
            var productId = "1"
            var offerId = "1"
            
            // Try to extract from endpoint enum case
            if case .purchaseOrderRule(let pid, let oid) = endpoint {
                productId = pid
                offerId = oid
            } else {
                // Fallback: try to parse from path
                let pathComponents = endpoint.path.components(separatedBy: "/")
                if let productsIndex = pathComponents.firstIndex(of: "products"),
                   productsIndex + 1 < pathComponents.count {
                    productId = pathComponents[productsIndex + 1]
                }
                if let offersIndex = pathComponents.firstIndex(of: "offers"),
                   offersIndex + 1 < pathComponents.count {
                    offerId = pathComponents[offersIndex + 1]
                }
            }
            
            // Get mock data from fixture
            let mockResponse = PurchaseInputValueFixture.mockResponse(
                productId: productId,
                offerId: offerId
            )
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("✅ Mock service returning success for order rules offer \(offerId)")
                if let response = mockResponse as? T {
                    completion(.success(response))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got \(type(of: mockResponse))")
                    completion(.failure(ApiError.decodingError))
                }
            }
        } else if endpoint.path.contains("/custody/") && !endpoint.path.contains("/total") {
            // Handle purchaseCustodyDetail endpoint - check for /custody/{offerId} pattern
            // Path format: invest/investplace/v1/products/{productId}/custody/{offerId}
            var productId = "1"
            var offerId = "1"
            
            // Try to extract from endpoint enum case
            if case .purchaseCustodyDetail(let pid, let oid) = endpoint {
                productId = pid
                offerId = oid
            } else {
                // Fallback: try to parse from path
                let pathComponents = endpoint.path.components(separatedBy: "/")
                if let productsIndex = pathComponents.firstIndex(of: "products"),
                   productsIndex + 1 < pathComponents.count {
                    productId = pathComponents[productsIndex + 1]
                }
                if let custodyIndex = pathComponents.firstIndex(of: "custody"),
                   custodyIndex + 1 < pathComponents.count {
                    offerId = pathComponents[custodyIndex + 1]
                }
            }
            
            // Get mock data from fixture - use PurchaseDetailFixture
            let mockResponse = PurchaseDetailFixture.mockResponse(
                productId: productId,
                offerId: offerId
            )
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("✅ Mock service returning success for custody detail offer \(offerId)")
                if let response = mockResponse as? T {
                    completion(.success(response))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got \(type(of: mockResponse))")
                    completion(.failure(ApiError.decodingError))
                }
            }
        } else if endpoint.path.contains("/offers/") && endpoint.path.components(separatedBy: "/").filter({ !$0.isEmpty }).count > 5 {
            // Handle purchaseOfferDetail endpoint - check for /offers/{offerId} pattern
            // Path format: invest/investplace/v1/products/{productId}/offers/{offerId}
            var productId = "1"
            var offerId = "1"
            
            // Try to extract from endpoint enum case
            if case .purchaseOfferDetail(let pid, let oid) = endpoint {
                productId = pid
                offerId = oid
            } else {
                // Fallback: try to parse from path
                let pathComponents = endpoint.path.components(separatedBy: "/")
                if let productsIndex = pathComponents.firstIndex(of: "products"),
                   productsIndex + 1 < pathComponents.count {
                    productId = pathComponents[productsIndex + 1]
                }
                if let offersIndex = pathComponents.firstIndex(of: "offers"),
                   offersIndex + 1 < pathComponents.count {
                    offerId = pathComponents[offersIndex + 1]
                }
            }
            
            // Get mock data from fixture
            // Try to get productTypeId from stored mapping
            let key = "\(productId):\(offerId)"
            var productTypeId = MockCoreService.shared.getProductTypeId(for: key) ?? productId // Fallback: infer from productId
            
            let mockResponse = PurchaseDetailFixture.mockResponse(
                productId: productId,
                offerId: offerId,
                productTypeId: productTypeId
            )
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("✅ Mock service returning success for detail offer \(offerId)")
                if let response = mockResponse as? T {
                    completion(.success(response))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got \(type(of: mockResponse))")
                    completion(.failure(ApiError.decodingError))
                }
            }
        } else if endpoint.path.contains("offers") || endpoint.path.contains("list") {
            // Handle purchaseOffers endpoint
            var productId = "1"
            var productTypeId = "1"
            
            // Try to extract from endpoint enum case
            if case .purchaseOffers(let pid, let ptid) = endpoint {
                productId = pid
                productTypeId = ptid
            }
            
            // Get mock data from fixture
            let mockResponse = PurchaseListFixture.mockResponse(
                productId: productId,
                productTypeId: productTypeId
            )
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("✅ Mock service returning success with \(mockResponse.data.count) offers")
                if let response = mockResponse as? T {
                    completion(.success(response))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got \(type(of: mockResponse))")
                    completion(.failure(ApiError.decodingError))
                }
            }
        } else if endpoint.path.contains("/offers/") && endpoint.path.components(separatedBy: "/").filter({ !$0.isEmpty }).count > 5 {
            // Handle purchaseOfferDetail endpoint - check for /offers/{offerId} pattern
            // Path format: invest/investplace/v1/products/{productId}/offers/{offerId}
            // This check MUST come before the list check because detail path contains "offers"
            var productId = "1"
            var offerId = "1"
            
            // Try to extract from endpoint enum case
            if case .purchaseOfferDetail(let pid, let oid) = endpoint {
                productId = pid
                offerId = oid
            } else {
                // Fallback: try to parse from path
                let pathComponents = endpoint.path.components(separatedBy: "/")
                if let productsIndex = pathComponents.firstIndex(of: "products"),
                   productsIndex + 1 < pathComponents.count {
                    productId = pathComponents[productsIndex + 1]
                }
                if let offersIndex = pathComponents.firstIndex(of: "offers"),
                   offersIndex + 1 < pathComponents.count {
                    offerId = pathComponents[offersIndex + 1]
                }
            }
            
            // Get mock data from fixture
            // Try to get productTypeId from stored mapping
            let key = "\(productId):\(offerId)"
            var productTypeId = MockCoreService.shared.getProductTypeId(for: key) ?? productId // Fallback: infer from productId
            
            let mockResponse = PurchaseDetailFixture.mockResponse(
                productId: productId,
                offerId: offerId,
                productTypeId: productTypeId
            )
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("✅ Mock service returning success for detail offer \(offerId)")
                if let response = mockResponse as? T {
                    completion(.success(response))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got \(type(of: mockResponse))")
                    completion(.failure(ApiError.decodingError))
                }
            }
        } else if endpoint.path.contains("offers") || endpoint.path.contains("list") {
            // Handle purchaseOffers endpoint (list of offers)
            var productId = "1"
            var productTypeId = "1"
            
            // Try to extract from endpoint enum case
            if case .purchaseOffers(let pid, let ptid) = endpoint {
                productId = pid
                productTypeId = ptid
            }
            
            // Get mock data from fixture
            let mockResponse = PurchaseListFixture.mockResponse(
                productId: productId,
                productTypeId: productTypeId
            )
            
            // Call completion on main thread after a small delay to simulate network
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("✅ Mock service returning success with \(mockResponse.data.count) offers")
                if let response = mockResponse as? T {
                    completion(.success(response))
                } else {
                    print("❌ Type mismatch: Expected \(T.self), got \(type(of: mockResponse))")
                    completion(.failure(ApiError.decodingError))
                }
            }
        } else {
            // For other endpoints, return error
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.failure(ApiError.unknown))
            }
        }
        
        return nil
    }
}

extension CoreServicing {
    func onMainThread(dependencies: HasAnalytics) -> CoreServicing {
        return self
    }
    
    func sentinel(dependencies: HasAnalytics, info: SentinelInfo) -> CoreServicing {
        return self
    }
}

struct SentinelInfo {
    let scene: String
}

// MARK: - Mock ConsumerManager

final class MockConsumerManager: ConsumerManagerProtocol {
    var consumerId: Int {
        return 12345 // Mock consumer ID
    }
}

// MARK: - Mock Auth

final class MockAuth: AuthProtocol {
    func authenticate(completion: @escaping (Result<String, Error>) -> Void) {
        // Mock authentication - always succeeds with a mock PIN
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success("1234"))
        }
    }
}

