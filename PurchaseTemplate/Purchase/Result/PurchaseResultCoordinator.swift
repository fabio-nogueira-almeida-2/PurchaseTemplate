import UIKit

protocol PurchaseResultCoordinating: AnyObject {
    func navigateToCatalog()
    func navigateToExtract(productId: String)
}

final class PurchaseResultCoordinator {
    typealias Dependencies = HasNavigationManager & HasDeeplinkOpener
    private let dependencies: Dependencies

    weak var viewController: UIViewController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseResultCoordinating
extension PurchaseResultCoordinator: PurchaseResultCoordinating {
    func navigateToCatalog() {
        // Dismiss result screen and go back to offers list
        viewController?.dismiss(animated: true) {
            // After dismissing result, we're back to the root
            // Navigate to offers list via deeplink
            if let navController = self.dependencies.navigationManager.getCurrentNavigation(),
               let deeplink = URL(string: "\(DeeplinkConfig.baseURL)purchase/offers?productId=1&productTypeId=1") {
                self.dependencies.deeplinkOpener.open(url: deeplink)
            }
        }
    }

    func navigateToExtract(productId: String) {
        // Dismiss result screen and navigate to custody/extract
        viewController?.dismiss(animated: true) {
            if let navController = self.dependencies.navigationManager.getCurrentNavigation(),
               let deeplink = URL(string: "\(DeeplinkConfig.baseURL)\(InvestmentsDeeplinkPath.purchaseCustody(productId: productId))") {
                // Pop to root if needed
                navController.popToRootViewController(animated: false)
                self.dependencies.deeplinkOpener.open(url: deeplink)
            }
        }
    }
}
