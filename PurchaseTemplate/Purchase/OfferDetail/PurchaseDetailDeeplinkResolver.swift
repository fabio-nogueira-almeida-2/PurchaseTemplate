import Core
import Foundation
import UIKitUtilities

final class PurchaseDetailDeeplinkResolver: DeeplinkResolver {
    typealias ViewControllerFactory = (String, String, UINavigationController) -> UIViewController

    private let dependencies: ModuleDependencies

    let viewControllerFactory: ViewControllerFactory

    convenience init(dependencies: ModuleDependencies) {
        self.init(
            dependencies: dependencies,
            viewControllerFactory: { offerId, productId, _  in
                PurchaseDetailFactory.make(offerId: offerId, productId: productId)
            })
    }

    init(dependencies: ModuleDependencies, viewControllerFactory: @escaping ViewControllerFactory) {
        self.dependencies = dependencies
        self.viewControllerFactory = viewControllerFactory
    }
    
    func canHandle(url: URL, isAuthenticated: Bool) -> DeeplinkResolverResult {
        let params: [String] = url.pathComponents.filter { $0 != "/" }
        guard
            let offerId = params.last,
            let productId = url.queryParameters["productId"] as? String,
            InvestmentsDeeplinkPath.purchaseOfferDetail(offerId: offerId, productId: productId).asDeeplink == url.absoluteString
        else {
            return .notHandleable
        }
        return isAuthenticated ? .handleable : .onlyWithAuth
    }

    func open(url: URL, isAuthenticated: Bool) -> Bool {
        let params: [String] = url.pathComponents.filter { $0 != "/" }
        guard
            let offerId = params.last,
            let productId = url.queryParameters["productId"] as? String,
            let navigation = dependencies.navigationManager.getCurrentNavigation()
        else {
            return false
        }
        let viewController = viewControllerFactory(offerId, productId, navigation)
        navigation.pushViewController(viewController, animated: true)
        return true
    }
}
