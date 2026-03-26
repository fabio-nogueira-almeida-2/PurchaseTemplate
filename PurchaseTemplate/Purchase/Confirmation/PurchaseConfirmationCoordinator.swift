import UI
import UIKit

enum PurchaseConfirmationAction {
    case result(String)
}

protocol PurchaseConfirmationCoordinating: AnyObject {
    func perform(action: PurchaseConfirmationAction)
}

final class PurchaseConfirmationCoordinator {
    typealias Dependencies = HasNavigationManager
    private let dependencies: Dependencies

    weak var viewController: UIViewController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    private func dismissViewsAndPresentResult(productId: String) {
        viewController?.navigationController?.dismiss(animated: true, completion: {
            self.presentResultView(productId: productId)
        })
    }

    private func presentResultView(productId: String) {
        let resultViewController = PurchaseResultFactory.make(productId: productId)
        guard let navigationController = dependencies
            .navigationManager
            .getCurrentNavigation()
        else { return }
        resultViewController.modalPresentationStyle = .fullScreen
        navigationController.topViewController?.present(resultViewController, animated: true)
    }
}

// MARK: - PurchaseConfirmationCoordinating
extension PurchaseConfirmationCoordinator: PurchaseConfirmationCoordinating {
    func perform(action: PurchaseConfirmationAction) {
        switch action {
            case .result(let productId):
                dismissViewsAndPresentResult(productId: productId)
        }
    }
}
