import Foundation

protocol PurchaseResultInteracting: AnyObject {
    func primaryButtonAction()
    func secondaryButtonAction()
}

final class PurchaseResultInteractor {
    typealias Dependencies = HasAnalytics
    private let dependencies: Dependencies

    private let presenter: PurchaseResultPresenting
    private let productId: String

    init(productId: String,
         presenter: PurchaseResultPresenting,
         dependencies: Dependencies) {
        self.productId = productId
        self.presenter = presenter
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseResultInteracting
extension PurchaseResultInteractor: PurchaseResultInteracting {
    func primaryButtonAction() {
        presenter.openCatalog()
    }

    func secondaryButtonAction() {
        presenter.openExtract(productId: productId)
    }
}

private extension PurchaseResultInteractor {
    func log(_ event: PurchaseResultAnalytics) {
        dependencies.analytics.log(event.event())
    }
}
