import UIKit

protocol PurchaseCustodyCoordinating: AnyObject {
    func navigateToCatalog(id: String)
    func navigateToCustodyDetail(productId: String, offerId: String)
    func navigateToFAQ()
}

final class PurchaseCustodyCoordinator {
    typealias Dependencies = HasDeeplinkOpener
    private let dependencies: Dependencies

    weak var viewController: UIViewController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseCustodyCoordinating
extension PurchaseCustodyCoordinator: PurchaseCustodyCoordinating {
    func navigateToCatalog(id: String) {
        guard
            let deeplink = URL(string: "\(DeeplinkConfig.baseURL)purchase/offers?productId=\(id)&productTypeId=1")
        else {
            return
        }
        dependencies.deeplinkOpener.open(url: deeplink)
    }

    func navigateToCustodyDetail(productId: String, offerId: String) {
        print("📱 Navigate to Custody Detail - productId: \(productId), offerId: \(offerId)")
        let vc = PurchaseCustodyDetailFactory.make(productId: productId, offerId: offerId)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToFAQ() {
        guard let url = URL(string: InvestmentsDeeplink.urlHelpCenterInvestmentHub.asDeeplink) else { return }
        dependencies.deeplinkOpener.open(url: url)
    }
}
