import Foundation

protocol PurchaseResultPresenting: AnyObject {
    func presentCatalog()
    func presentStatement()
}

final class PurchaseResultPresenter {
    private let coordinator: PurchaseResultCoordinating
    
    init(coordinator: PurchaseResultCoordinating) {
        self.coordinator = coordinator
    }
}

extension PurchaseResultPresenter: PurchaseResultPresenting {
    func presentCatalog() {
        coordinator.navigateToCatalog()
    }
    
    func presentStatement() {
        coordinator.navigateToStatement()
    }
}
