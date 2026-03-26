import UIKit

protocol PurchaseListCoordinating: AnyObject {
    func navigateToDetail(index: Int)
}

final class PurchaseListCoordinator: PurchaseListCoordinating {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = PurchaseListService()
        let presenter = PurchaseListPresenter(coordinator: self)
        let interactor = PurchaseListInteractor(service: service, presenter: presenter)
        let viewController = PurchaseListViewController(interactor: interactor)
        
        presenter.viewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToDetail(index: Int) {
        let alert = UIAlertController(title: "Navigate to Detail", message: "Selected item at index: \(index)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}
