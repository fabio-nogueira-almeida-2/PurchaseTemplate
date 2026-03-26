import UIKit

protocol PurchaseInputValueCoordinating {
    func openConfirmTransaction(model: PurchaseOrderModel)
}

final class PurchaseInputValueCoordinator {
    typealias Dependencies = HasNoDependency
    private let dependencies: Dependencies

    weak var viewController: UIViewController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - InsertValueTransferCoordinating
extension PurchaseInputValueCoordinator: PurchaseInputValueCoordinating {
    func openConfirmTransaction(model: PurchaseOrderModel) {
        let confirmViewController = PurchaseConfirmationFactory.make(model: model)
        viewController?.navigationController?.pushViewController(confirmViewController, animated: true)
    }
}
