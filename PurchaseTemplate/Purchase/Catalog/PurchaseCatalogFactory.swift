import UIKit

enum PurchaseCatalogFactory {
    static func make() -> UIViewController {
        let dependencies = DependencyContainer()
        let service = PurchaseCatalogService(service: dependencies.coreService)
        let coordinator = PurchaseCatalogCoordinator(dependencies: dependencies)
        let presenter = PurchaseCatalogPresenter(coordinator: coordinator, dependencies: HasNoDependencyImpl())
        let interactor = PurchaseCatalogInteractor(
            service: service,
            presenter: presenter,
            dependencies: dependencies
        )
        // Use PurchaseCustodyViewController for catalog display
        // PurchaseCatalogInteractor conforms to PurchaseCustodyInteracting via extension
        let viewController = PurchaseCustodyViewController(interactor: interactor)

        coordinator.viewController = viewController
        // PurchaseCustodyViewController conforms to PurchaseCustodyDisplaying
        // PurchaseCatalogDisplaying inherits from PurchaseCustodyDisplaying
        if let custodyDisplaying = viewController as? PurchaseCustodyDisplaying {
            // Set both references to ensure display works
            presenter.viewController = custodyDisplaying as? PurchaseCatalogDisplaying
            presenter.custodyViewController = custodyDisplaying
            print("✅ PurchaseCatalogFactory: Set viewController on presenter (both references)")
        } else {
            print("❌ PurchaseCatalogFactory: Failed to cast viewController to PurchaseCustodyDisplaying")
        }

        return viewController
    }
}

