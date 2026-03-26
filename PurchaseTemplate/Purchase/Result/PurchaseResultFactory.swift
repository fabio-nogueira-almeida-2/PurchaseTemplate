import UIKit

enum PurchaseResultFactory {
    static func make(productId: String) -> UIViewController {
        let container = DependencyContainer()
        let coordinator = PurchaseResultCoordinator(dependencies: container)
        let presenter = PurchaseResultPresenter(coordinator: coordinator, dependencies: HasNoDependencyImpl())
        let interactor = PurchaseResultInteractor(
            productId: productId,
            presenter: presenter,
            dependencies: container
        )
        let viewController = PurchaseResultViewController(interactor: interactor)
        coordinator.viewController = viewController
        presenter.viewController = viewController
        return viewController
    }
}
