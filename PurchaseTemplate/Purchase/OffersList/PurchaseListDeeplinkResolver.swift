import Foundation
import UIKit

final class PurchaseListDeeplinkResolver: DeeplinkResolver {
    typealias ViewControllerFactory = (UINavigationController, String, String) -> UIViewController

    private let dependencies: ModuleDependencies

    let viewControllerFactory: ViewControllerFactory

    convenience init(dependencies: ModuleDependencies) {
        self.init(dependencies: dependencies, viewControllerFactory: { _, productId, productTypeId  in
            PurchaseListFactory.make(productId: productId, productTypeId: productTypeId)
        })
    }

    init(dependencies: ModuleDependencies, viewControllerFactory: @escaping ViewControllerFactory) {
        self.dependencies = dependencies
        self.viewControllerFactory = viewControllerFactory
    }

    func canHandle(url: URL, isAuthenticated: Bool) -> DeeplinkResolverResult {
        // Check if path matches purchase/offers or purchase/list pattern
        let path = url.path
        guard path == "/purchase/offers" || path.hasPrefix("/purchase/list/") else {
            return .notHandleable
        }
        return isAuthenticated ? .handleable : .onlyWithAuth
    }

    func open(url: URL, isAuthenticated: Bool) -> Bool {
        let productTypeId = url.queryParameters["productTypeId"] as? String ?? ""
        guard
            let productType = url.queryParameters["productId"] as? String,
            let navigation = dependencies.navigationManager.getCurrentNavigation()
        else {
            return false
        }
        let viewController = viewControllerFactory(navigation, productType, productTypeId)
        navigation.pushViewController(viewController, animated: true)

        return true
    }
}
