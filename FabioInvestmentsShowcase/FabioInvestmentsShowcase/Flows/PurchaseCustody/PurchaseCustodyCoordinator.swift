import UIKit

protocol PurchaseCustodyCoordinating: AnyObject {
    func navigateToCatalog(id: String)
    func navigateToCustodyDetail(productId: String, offerId: String)
    func navigateToFAQ()
}

final class PurchaseCustodyCoordinator: PurchaseCustodyCoordinating {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = PurchaseCustodyService()
        let presenter = PurchaseCustodyPresenter()
        let interactor = PurchaseCustodyInteractor(
            service: service,
            presenter: presenter,
            dependencies: MockDependencies(),
            productId: "123"
        )
        let viewController = PurchaseCustodyViewController(interactor: interactor)
        
        presenter.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToCatalog(id: String) {
        let alert = UIAlertController(title: "Navigate to Catalog", message: "Product ID: \(id)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func navigateToCustodyDetail(productId: String, offerId: String) {
        let alert = UIAlertController(title: "Navigate to Detail", message: "Product ID: \(productId), Offer ID: \(offerId)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func navigateToFAQ() {
        let alert = UIAlertController(title: "FAQ", message: "Frequently Asked Questions", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}

