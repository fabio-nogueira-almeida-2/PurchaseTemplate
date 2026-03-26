import Foundation

protocol PurchaseResultInteracting: AnyObject {
    func primaryButtonAction()
    func secondaryButtonAction()
}

final class PurchaseResultInteractor {
    private let presenter: PurchaseResultPresenting
    
    init(presenter: PurchaseResultPresenting) {
        self.presenter = presenter
    }
}

extension PurchaseResultInteractor: PurchaseResultInteracting {
    func primaryButtonAction() {
        presenter.presentCatalog()
    }
    
    func secondaryButtonAction() {
        presenter.presentStatement()
    }
}
