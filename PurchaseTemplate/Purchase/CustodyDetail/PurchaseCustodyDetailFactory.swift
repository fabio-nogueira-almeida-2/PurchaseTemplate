import UIKit

enum PurchaseCustodyDetailFactory {
    static func make(productId: String, offerId: String) -> UIViewController {
        let container = DependencyContainer()
        let service = PurchaseCustodyDetailService(service: container.coreService
            .onMainThread(dependencies: container)
            .sentinel(
                dependencies: container, info: .init(scene: "PURCHASE-CUSTODY-DETAIL")
            )
        )
        let coordinator = PurchaseDetailCoordinator(dependencies: container)
        let presenter = PurchaseDetailPresenter(coordinator: coordinator, dependencies: container)
        let interactor = PurchaseDetailInteractor(
            offerId: offerId,
            productId: productId,
            service: service,
            presenter: presenter,
            dependencies: container
        )
        let viewController = PurchaseDetailViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
