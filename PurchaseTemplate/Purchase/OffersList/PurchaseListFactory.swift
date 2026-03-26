import UIKit

enum PurchaseListFactory {
    static func make(productId: String, productTypeId: String) -> UIViewController {
        let dependencies = DependencyContainer()
        let service = PurchaseListService(service: dependencies.coreService)
        let coordinator = PurchaseListCoordinator(dependencies: dependencies)
        let presenter = PurchaseListPresenter(coordinator: coordinator, dependencies: HasNoDependencyImpl())
        let interactor = PurchaseListInteractor(
            service: service,
            presenter: presenter,
            dependencies: dependencies,
            productId: productId,
            productTypeId: productTypeId
        )
        let viewController = PurchaseListViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}

struct HasNoDependencyImpl: HasNoDependency {}
