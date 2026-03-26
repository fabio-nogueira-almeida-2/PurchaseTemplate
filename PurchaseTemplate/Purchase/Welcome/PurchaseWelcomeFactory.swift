import UIKit

enum PurchaseWelcomeFactory {
    static func make(productId: String, productTypeId: String) -> UIViewController {
        let dependencies = DependencyContainer()
        let service = PurchaseWelcomeService(service: dependencies.coreService)
        let coordinator = PurchaseWelcomeCoordinator(dependencies: dependencies)
        let presenter = PurchaseWelcomePresenter(coordinator: coordinator)
        let interactor = PurchaseWelcomeInteractor(
            service: service,
            presenter: presenter,
            dependencies: dependencies,
            productId: productId,
            productTypeId: productTypeId
        )
        let viewController = PurchaseWelcomeViewController(interactor: interactor)
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        // Set up navigation controller reference after view loads
        DispatchQueue.main.async {
            if let navController = viewController.navigationController {
                if let mockDeeplinkOpener = dependencies.deeplinkOpener as? MockDeeplinkOpener {
                    mockDeeplinkOpener.setNavigationController(navController)
                    print("✅ PurchaseWelcomeFactory: Set navigation controller in MockDeeplinkOpener")
                }
            }
        }
        
        return viewController
    }
}
