//
//  MockProtocols.swift
//  PurchaseTemplate
//
//  Mock implementations for missing dependencies
//

import Foundation
import UIKit

protocol NavigationManagerProtocol {
    func getCurrentNavigation() -> UINavigationController?
}

protocol HasNavigationManager {
    var navigationManager: NavigationManagerProtocol { get }
}

// MARK: - Core Protocols

protocol CoreServicing {
    func request<T: Decodable>(
        endpoint: InvestmentsEndpoint,
        decoder: JSONDecoder,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask?
}

protocol HasAnalytics {
    var analytics: AnalyticsProtocol { get }
}

protocol HasFeatureManager {
    var featureManager: FeatureManagerProtocol { get }
}

protocol HasDeeplinkOpener {
    var deeplinkOpener: DeeplinkOpenerProtocol { get }
}

protocol HasWebViewFactory {
    var webView: WebViewFactoryProtocol { get }
}

protocol AnalyticsProtocol {
    func log(_ event: AnalyticsEventProtocol)
}

protocol FeatureManagerProtocol {
    func value(for key: FeatureFlagKey) -> Bool?
}

protocol DeeplinkOpenerProtocol {
    func open(url: URL)
}

protocol WebViewFactoryProtocol {
    func make(with url: URL, properties: WebViewProperties, completion: @escaping (Bool) -> Void) -> UIViewController
}

protocol AnalyticsEventProtocol {
    var name: String { get }
    var properties: [String: Any] { get }
}

struct AnalyticsEvent: AnalyticsEventProtocol {
    let name: String
    let properties: [String: Any]
}

struct WebViewProperties {
    // Add properties as needed
}

enum FeatureFlagKey: String {
    case isMusicRoyaltiesMaintenanceAvailable
}

// MARK: - JSONDecoder Extension

extension JSONDecoder {
    static func useDefaultKeys() -> JSONDecoder {
        let decoder = JSONDecoder()
        // Use default key decoding strategy (convertFromSnakeCase is common, but we'll use default)
        return decoder
    }
}

// MARK: - Deeplink Configuration

struct DeeplinkConfig {
    static let scheme = "purchasetemplate"
    static let host = "purchasetemplate"
    
    static var baseURL: String {
        return "\(scheme)://"
    }
}

// MARK: - InvestmentsEndpoint

enum InvestmentsEndpoint {
    case purchaseWelcome(productId: String, productTypeId: String)
    case purchaseOrders(productId: String)
    case purchaseOrderDetail(productId: String, offerId: String)
    case purchaseCustody(productId: String)
    case purchaseCustodyDetail(productId: String, offerId: String)
    case purchaseCustodyPosition(productId: String)
    case purchaseOffers(productId: String, productTypeId: String)
    case purchaseCatalog  // Shows all investments regardless of type
    case purchaseOfferDetail(productId: String, offerId: String)
    case purchaseOrderRule(productId: String, offerId: String)
    case purchaseOrder(consumerId: String, productId: String, offerId: String, model: PurchaseOrderRequest)
    
    var path: String {
        switch self {
        case .purchaseWelcome(let productId, let productTypeId):
            return "invest/investplace/v1/products/\(productId)/type/\(productTypeId)/welcome"
        case .purchaseOrders(let productId):
            return "invest/investplace/v1/products/\(productId)/orders"
        case .purchaseOrderDetail(let productId, let offerId):
            return "invest/investplace/v1/products/\(productId)/orders/\(offerId)"
        case .purchaseCustody(let productId):
            return "invest/investplace/v1/products/\(productId)/custody"
        case .purchaseCustodyDetail(let productId, let offerId):
            return "invest/investplace/v1/products/\(productId)/custody/\(offerId)"
        case .purchaseCustodyPosition(let productId):
            return "invest/investplace/v1/products/\(productId)/total"
        case .purchaseOffers(let productId, _):
            return "invest/investplace/v1/products/\(productId)/offers"
        case .purchaseCatalog:
            return "invest/investplace/v1/catalog"
        case .purchaseOfferDetail(let productId, let offerId):
            return "invest/investplace/v1/products/\(productId)/offers/\(offerId)"
        case .purchaseOrderRule(let productId, let offerId):
            return "invest/investplace/v1/products/\(productId)/offers/\(offerId)/rules"
        case .purchaseOrder(let consumerId, let productId, let offerId, _):
            return "invest/investplace/v1/products/\(productId)/orders/offers/\(offerId)/buy"
        }
    }
    
    var method: String {
        switch self {
        case .purchaseOrder:
            return "POST"
        default:
            return "GET"
        }
    }
    
    var body: Data? {
        switch self {
        case .purchaseOrder(_, _, _, let model):
            return try? JSONEncoder().encode(model)
        default:
            return nil
        }
    }
    
    var customHeaders: [String: String]? {
        switch self {
        case .purchaseOrder(let consumerId, _, _, _):
            return ["consumer_id": consumerId]
        default:
            return nil
        }
    }
}

struct PurchaseOrderRequest: Codable {
    let value: Double
    let amount: Double?
    
    init(value: Double, amount: Double?) {
        self.value = value
        self.amount = amount
    }
}

enum InvestmentsDeeplinkPath {
    static func purchaseWelcome(productId: String, productTypeId: String) -> String {
        return "/purchase/welcome"
    }
    
    static func purchaseCustody(productId: String) -> String {
        return "/purchase/custody/\(productId)"
    }
    
    static func purchaseList(productId: String) -> String {
        return "/purchase/list/\(productId)"
    }
    
    static func purchaseOfferDetail(offerId: String, productId: String) -> InvestmentsDeeplink {
        return InvestmentsDeeplink.purchaseOfferDetail(offerId: offerId, productId: productId)
    }
}

enum InvestmentsDeeplink {
    case purchaseOfferDetail(offerId: String, productId: String)
    case urlHelpCenterInvestmentHub
    
    var asDeeplink: String {
        switch self {
        case .purchaseOfferDetail(let offerId, let productId):
            return "\(DeeplinkConfig.baseURL)purchase/offer/\(productId)/\(offerId)"
        case .urlHelpCenterInvestmentHub:
            return "\(DeeplinkConfig.baseURL)help/investment"
        }
    }
}

// MARK: - ApiError

enum ApiError: Error {
    case networkError
    case decodingError
    case unknown
    
    var apiError: ApiError {
        return self
    }
    
    var feedback: InvestmentsHubFeedback {
        switch self {
        case .networkError:
            return .connectionFailureError
        default:
            return .genericError
        }
    }
}

enum InvestmentsHubFeedback {
    case connectionFailureError
    case genericError
    case maintenanceError
}

// MARK: - Analytics Keys

protocol AnalyticsKeyProtocol {
    func event() -> AnalyticsEventProtocol
}

struct EventKeys {
    static let screenName = "screen_name"
    static let businessContext = "business_context"
    static let buttonName = "button_name"
}

struct EventName {
    static let screenViewed = "screen_viewed"
    static let buttonClicked = "button_clicked"
}

