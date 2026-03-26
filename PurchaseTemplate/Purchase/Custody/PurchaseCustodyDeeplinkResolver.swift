import Core
import Foundation
import UIKitUtilities

final class PurchaseCustodyDeeplinkResolver: DeeplinkResolver {
    typealias ViewControllerFactory = (UINavigationController, String) -> UIViewController

    private let dependencies: ModuleDependencies

    let viewControllerFactory: ViewControllerFactory

    convenience init(dependencies: ModuleDependencies) {
        self.init(dependencies: dependencies, viewControllerFactory: { _, productId  in
            PurchaseCustodyFactory.make(productId: productId)
        })
    }

    init(dependencies: ModuleDependencies, viewControllerFactory: @escaping ViewControllerFactory) {
        self.dependencies = dependencies
        self.viewControllerFactory = viewControllerFactory
    }

    func canHandle(url: URL, isAuthenticated: Bool) -> DeeplinkResolverResult {
        guard
            let productId = url.queryParameters["productId"] as? String,
            InvestmentsDeeplinkPath.purchaseCustody(productId: productId).asDeeplink == url.absoluteString
        else {
            return .notHandleable
        }
        return isAuthenticated ? .handleable : .onlyWithAuth
    }

    func open(url: URL, isAuthenticated: Bool) -> Bool {
        guard
            let productTypeIdParam = url.queryParameters["productId"] as? String,
            let navigation = dependencies.navigationManager.getCurrentNavigation()
        else {
            return false
        }
        let viewController = viewControllerFactory(navigation, productTypeIdParam)
        navigation.pushViewController(viewController, animated: true)
        return true
    }
}
