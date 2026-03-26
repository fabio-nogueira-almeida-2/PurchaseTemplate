import UIKit

protocol OrdersCoordinating: AnyObject {
    func navigateToOrderDetail(orderId: String)
}

final class OrdersCoordinator: OrdersCoordinating {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = OrdersViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToOrderDetail(orderId: String) {
        let alert = UIAlertController(title: "Order Detail", message: "Order ID: \(orderId)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}
