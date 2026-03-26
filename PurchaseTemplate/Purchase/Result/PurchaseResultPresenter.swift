protocol PurchaseResultPresenting: AnyObject {
    func openCatalog()
    func openExtract(productId: String)
}

final class PurchaseResultPresenter {
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies

    private let coordinator: PurchaseResultCoordinating
    weak var viewController: PurchaseResultDisplaying?

    init(coordinator: PurchaseResultCoordinating, dependencies: Dependencies) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseResultPresenting
extension PurchaseResultPresenter: PurchaseResultPresenting {
    func openCatalog() {
        coordinator.navigateToCatalog()
    }

    func openExtract(productId: String) {
        coordinator.navigateToExtract(productId: productId)
    }
}
