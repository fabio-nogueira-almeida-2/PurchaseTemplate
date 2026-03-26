import UIKit

enum PurchaseConfirmationFactory {
    static func make(model: PurchaseOrderModel) -> UIViewController {
        let container = DependencyContainer()
        let service = PurchaseConfirmationService(
            service: container.coreService,
            dependencies: container
        )
        let coordinator = PurchaseConfirmationCoordinator(dependencies: container)
        let presenter = PurchaseConfirmationPresenter(coordinator: coordinator, dependencies: HasNoDependencyImpl())
        let interactor = PurchaseConfirmationInteractor(
            service: service,
            presenter: presenter,
            dependencies: container,
            model: model
        )
        let viewController = PurchaseConfirmationViewController(interactor: interactor)
        coordinator.viewController = viewController
        presenter.viewController = viewController
        return viewController
    }
}
