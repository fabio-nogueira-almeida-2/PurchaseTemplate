import UIKit

protocol PurchaseCatalogCoordinating: AnyObject {
    func perform(action: PurchaseCatalogAction)
    func navigateToDashboard()
}

final class PurchaseCatalogCoordinator {
    typealias Dependencies = HasDeeplinkOpener
    private let dependencies: Dependencies

    weak var viewController: UIViewController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseCatalogCoordinating
extension PurchaseCatalogCoordinator: PurchaseCatalogCoordinating {
    func perform(action: PurchaseCatalogAction) {
        switch action {
            case let .detail(offerId, productId, productTypeId):
                // Include productTypeId in the deeplink URL
                print("🔗 PurchaseCatalogCoordinator creating deeplink:")
                print("   offerId: \(offerId)")
                print("   productId: \(productId)")
                print("   productTypeId: \(productTypeId)")
                
                let deeplinkString = "\(DeeplinkConfig.baseURL)purchase/offer/\(productId)/\(offerId)?productId=\(productId)&offerId=\(offerId)&productTypeId=\(productTypeId)"
                print("   Deeplink: \(deeplinkString)")
                
                guard let url = URL(string: deeplinkString) else {
                    print("❌ Failed to create URL from: \(deeplinkString)")
                    return
                }
                dependencies.deeplinkOpener.open(url: url)
        }
    }
    
    func navigateToDashboard() {
        // Navigate back to dashboard
        print("🔗 PurchaseCatalogCoordinator: Navigating to dashboard")
        if let navController = viewController?.navigationController {
            navController.popToRootViewController(animated: true)
        } else {
            // If no navigation controller, try to dismiss and navigate via deeplink
            viewController?.dismiss(animated: true) {
                // Navigate to dashboard via deeplink if available
                if let dashboardURL = URL(string: "\(DeeplinkConfig.baseURL)dashboard") {
                    self.dependencies.deeplinkOpener.open(url: dashboardURL)
                }
            }
        }
    }
}


