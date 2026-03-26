import UIKit

enum PurchaseWelcomeFactory {
    static func make(productId: String, productTypeId: String) -> UIViewController {
        let container = DependencyContainer()
        let service = PurchaseWelcomeService(service: container.coreService
            .onMainThread(dependencies: container)
            .sentinel(
                dependencies: container, info: .init(scene: "Purchase")
            )
        )
        let coordinator = PurchaseWelcomeCoordinator(dependencies: container)
        let presenter = PurchaseWelcomePresenter(coordinator: coordinator)
        let interactor = PurchaseWelcomeInteractor(
            service: service,
            presenter: presenter,
            dependencies: container,
            productId: productId,
            productTypeId: productTypeId
        )
        let viewController = PurchaseWelcomeViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
