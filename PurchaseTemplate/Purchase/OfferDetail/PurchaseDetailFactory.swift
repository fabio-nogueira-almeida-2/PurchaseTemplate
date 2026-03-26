import UIKit

enum PurchaseDetailFactory {
    static func make(offerId: String, productId: String, productTypeId: String? = nil) -> UIViewController {
        let dependencies = DependencyContainer()
        let service = PurchaseDetailService(service: dependencies.coreService)
        let coordinator = PurchaseDetailCoordinator(dependencies: dependencies)
        let presenter = PurchaseDetailPresenter(coordinator: coordinator, dependencies: HasNoDependencyImpl())
        let interactor = PurchaseDetailInteractor(
            offerId: offerId,
            productId: productId,
            productTypeId: productTypeId,
            service: service,
            presenter: presenter,
            dependencies: dependencies
        )
        let viewController = PurchaseDetailViewController(interactor: interactor)
        coordinator.viewController = viewController
        presenter.viewController = viewController
        return viewController
    }
}
