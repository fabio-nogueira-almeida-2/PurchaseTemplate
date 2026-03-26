import UIKit

protocol PurchaseDetailCoordinating: AnyObject {
    func navigateToConfirmation()
    func navigateToDocument(urlString: String)
}

final class PurchaseDetailCoordinator: PurchaseDetailCoordinating {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = PurchaseDetailService()
        let presenter = PurchaseDetailPresenter(coordinator: self)
        let interactor = PurchaseDetailInteractor(service: service, presenter: presenter)
        let viewController = PurchaseDetailViewController(interactor: interactor)
        
        presenter.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToConfirmation() {
        let alert = UIAlertController(title: "Confirmation", message: "Investment confirmed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func navigateToDocument(urlString: String) {
        let alert = UIAlertController(title: "Document", message: "Opening document: \(urlString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}

