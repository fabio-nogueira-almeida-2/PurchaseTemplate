import UIKit

protocol PurchaseResultCoordinating: AnyObject {
    func navigateToCatalog()
    func navigateToStatement()
}

final class PurchaseResultCoordinator: PurchaseResultCoordinating {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = PurchaseResultPresenter(coordinator: self)
        let interactor = PurchaseResultInteractor(presenter: presenter)
        let viewController = PurchaseResultViewController(interactor: interactor)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToCatalog() {
        let alert = UIAlertController(title: "Navigate to Catalog", message: "Returning to investment catalog", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func navigateToStatement() {
        let alert = UIAlertController(title: "Navigate to Statement", message: "Opening investment statement", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}
