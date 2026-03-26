// import Core // Commented out - replaced with mock implementation
import Foundation
// import UIKitUtilities // Commented out - replaced with mock implementation
import UIKit

// MARK: - Mock DeeplinkResolver Protocol
protocol DeeplinkResolver {
    func canHandle(url: URL, isAuthenticated: Bool) -> DeeplinkResolverResult
    func open(url: URL, isAuthenticated: Bool) -> Bool
}

enum DeeplinkResolverResult {
    case handleable
    case notHandleable
    case onlyWithAuth
}

protocol ModuleDependencies {
    var navigationManager: NavigationManagerProtocol { get }
}

extension URL {
    var queryParameters: [String: Any] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        var params: [String: Any] = [:]
        for item in queryItems {
            params[item.name] = item.value ?? ""
        }
        return params
    }
}

final class PurchaseWelcomeDeeplinkResolver: DeeplinkResolver {
    typealias ViewControllerFactory = (UINavigationController, String, String) -> UIViewController

    private let dependencies: ModuleDependencies

    let viewControllerFactory: ViewControllerFactory

    convenience init(dependencies: ModuleDependencies) {
        self.init(dependencies: dependencies, viewControllerFactory: { _, productId, productTypeId  in
            PurchaseWelcomeFactory.make(productId: productId, productTypeId: productTypeId)
        })
    }

    init(dependencies: ModuleDependencies, viewControllerFactory: @escaping ViewControllerFactory) {
        self.dependencies = dependencies
        self.viewControllerFactory = viewControllerFactory
    }

    func canHandle(url: URL, isAuthenticated: Bool) -> DeeplinkResolverResult {
        guard
            let productId = url.queryParameters["productId"] as? String,
            let productTypeId = url.queryParameters["productTypeId"] as? String,
            InvestmentsDeeplinkPath.purchaseWelcome(
                productId: productId,
                productTypeId: productTypeId
            ) == url.path
        else {
            return .notHandleable
        }
        return isAuthenticated ? .handleable : .onlyWithAuth
    }

    func open(url: URL, isAuthenticated: Bool) -> Bool {
        guard
            let productType = url.queryParameters["productId"] as? String,
            let productTypeId = url.queryParameters["productTypeId"] as? String,
            let navigation = dependencies.navigationManager.getCurrentNavigation()
        else {
            return false
        }
        let viewController = viewControllerFactory(navigation, productType, productTypeId)
        viewController.hidesBottomBarWhenPushed = true
        navigation.pushViewController(viewController, animated: true)

        return true
    }
}
