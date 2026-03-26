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

    private func presentResultView(productId: String) {
        let resultViewController = PurchaseResultFactory.make(productId: productId)
        
        // The confirmation screen is pushed onto the InputValue navigation controller
        // We need to dismiss the entire modal (InputValue + Confirmation) and present Result
        if let navigationController = viewController?.navigationController,
           let presentingViewController = navigationController.presentingViewController {
            // Dismiss the entire modal stack (InputValue + Confirmation)
            presentingViewController.dismiss(animated: true) {
                // After dismissing, present the result screen from the root
                if let rootNavController = self.dependencies.navigationManager.getCurrentNavigation() {
                    resultViewController.modalPresentationStyle = .fullScreen
                    rootNavController.topViewController?.present(resultViewController, animated: true)
                } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first,
                          let rootVC = window.rootViewController {
                    resultViewController.modalPresentationStyle = .fullScreen
                    rootVC.present(resultViewController, animated: true)
                }
            }
        } else {
            // Fallback: try to get navigation controller from dependencies
            if let navigationController = dependencies.navigationManager.getCurrentNavigation() {
                resultViewController.modalPresentationStyle = .fullScreen
                navigationController.topViewController?.present(resultViewController, animated: true)
            }
        }
    }
}

// MARK: - PurchaseConfirmationCoordinating
extension PurchaseConfirmationCoordinator: PurchaseConfirmationCoordinating {
    func perform(action: PurchaseConfirmationAction) {
        switch action {
            case .result(let productId):
                presentResultView(productId: productId)
        }
    }
}
