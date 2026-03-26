import UIKit

enum PurchaseCustodyFactory {
    static func make(productId: String) -> UIViewController {
        let container = DependencyContainer()
        let service = PurchaseCustodyService(service: container.coreService
            .onMainThread(dependencies: container)
            .sentinel(
                dependencies: container,
                info: .init(scene: "PURCHASE-CUSTODY")
            )
        )
        let coordinator = PurchaseCustodyCoordinator(dependencies: container)
        let presenter = PurchaseCustodyPresenter(coordinator: coordinator)
        let interactor = PurchaseCustodyInteractor(
            service: service,
            presenter: presenter,
            dependencies: container,
            productId: productId
        )
        let viewController = PurchaseCustodyViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
