import UIKit

enum PurchaseCustodyDetailFactory {
    static func make(productId: String, offerId: String) -> UIViewController {
        let dependencies = DependencyContainer()
        let service = PurchaseCustodyDetailService(service: dependencies.coreService)
        let coordinator = PurchaseDetailCoordinator(dependencies: dependencies)
        let presenter = PurchaseDetailPresenter(coordinator: coordinator, dependencies: HasNoDependencyImpl())
        let interactor = PurchaseDetailInteractor(
            offerId: offerId,
            productId: productId,
            productTypeId: nil, // Custody detail doesn't need productTypeId
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
