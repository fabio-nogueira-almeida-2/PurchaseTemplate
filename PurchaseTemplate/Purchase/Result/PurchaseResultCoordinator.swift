import Core
import UI
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

// MARK: - RoyaltyResultCoordinating
extension PurchaseResultCoordinator: PurchaseResultCoordinating {
    func navigateToCatalog() {
        guard let navigationController = dependencies.navigationManager.getCurrentNavigation() else { return }
        navigationController.dismiss(animated: true)
        navigationController.popViewController(animated: false)
    }

    func navigateToExtract(productId: String) {
        guard
            let navigationController = dependencies.navigationManager.getCurrentNavigation(),
            let deeplink = URL(string: InvestmentsDeeplinkPath.purchaseCustody(productId: productId))
        else {
            return
        }
        navigationController.dismiss(animated: true)
        navigationController.popToRootViewController(animated: false)
        dependencies.deeplinkOpener.open(url: deeplink)
    }
}
