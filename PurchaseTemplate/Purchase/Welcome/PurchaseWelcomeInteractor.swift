// import CoreTrackingInterface // Commented out - replaced with mock implementation
// import FeatureFlag // Commented out - replaced with mock implementation
import Foundation

protocol PurchaseWelcomeInteracting: AnyObject {
    func loadWelcomeData()
    func handleDeeplink(urlString: String)
}

final class PurchaseWelcomeInteractor {
    typealias Dependencies = HasAnalytics & HasFeatureManager
    private let dependencies: Dependencies

    var isMusicRoyaltiesMaintenanceAvailable: Bool {
        dependencies.featureManager.value(for: .isMusicRoyaltiesMaintenanceAvailable) ?? false
    }
    private let service: PurchaseWelcomeServicing
    private let presenter: PurchaseWelcomePresenting
    private let productId: String
    private let productTypeId: String

    init(
        service: PurchaseWelcomeServicing,
        presenter: PurchaseWelcomePresenting,
        dependencies: Dependencies,
        productId: String,
        productTypeId: String
    ) {
        self.service = service
        self.presenter = presenter
        self.dependencies = dependencies
        self.productId = productId
        self.productTypeId = productTypeId
    }
}

// MARK: - PurchaseWelcomeInteracting
extension PurchaseWelcomeInteractor: PurchaseWelcomeInteracting {
    func loadWelcomeData() {
        log(.screenViewed)
        guard !isMusicRoyaltiesMaintenanceAvailable else {
            presenter.presentMaintenanceScreen()
            return
        }
        presenter.startLoading()
        service.getWelcomeData(productId: productId,
                               productTypeId: productTypeId) { [weak self] result in
            switch result {
            case .success(let response):
                print("✅ Interactor received success: \(response.data.items.count) items")
                self?.presenter.present(model: response.data)
            case .failure(let error):
                print("❌ Interactor received error: \(error)")
                self?.presenter.presentError(error)
            }
            self?.presenter.stopLoading()
        }
    }

    func handleDeeplink(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        if urlString.hasPrefix(DeeplinkConfig.baseURL) || urlString.hasPrefix("\(DeeplinkConfig.scheme)://") {
            presenter.openDeeplink(url: url)
        } else if urlString.hasPrefix("https://") {
            presenter.openWebView(url: url)
        }
    }
}

private extension PurchaseWelcomeInteractor {
    func log(_ event: PurchaseWelcomeAnalytics) {
        dependencies.analytics.log(event.event())
    }
}
