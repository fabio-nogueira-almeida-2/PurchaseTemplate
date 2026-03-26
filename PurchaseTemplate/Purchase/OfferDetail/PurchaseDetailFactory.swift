import UIKit

enum PurchaseDetailFactory {
    static func make(offerId: String, productId: String) -> UIViewController {
        let dependencies = DependencyContainer()
        let service = PurchaseDetailService(service: dependencies.coreService
            .onMainThread(dependencies: dependencies)
            .sentinel(
                dependencies: dependencies, info: .init(scene: "PURCHASE-DETAIL")
            )
        )
        let coordinator = PurchaseDetailCoordinator(dependencies: dependencies)
        let presenter = PurchaseDetailPresenter(coordinator: coordinator, dependencies: dependencies)
        let interactor = PurchaseDetailInteractor(
            offerId: offerId,
            productId: productId,
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
