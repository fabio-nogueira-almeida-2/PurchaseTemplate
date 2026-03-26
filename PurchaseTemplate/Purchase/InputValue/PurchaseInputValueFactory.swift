import UIKit

enum PurchaseInputValueFactory {
    static func make(orderModel: PurchaseOrderModel) -> UIViewController {
        let container = DependencyContainer()
        let coordinator = PurchaseInputValueCoordinator(dependencies: container)
        let presenter = PurchaseInputValuePresenter(coordinator: coordinator)
        let analytics = InsertValueTransferAnalyticsImpl(type: .out, dependencies: container)
        let service = PurchaseInputValueService(
            service: container.coreService
                .onMainThread(dependencies: container)
                .sentinel(
                    dependencies: container,
                    info: .init(scene: "Purchase")
                )
        )
        let interactor = PurchaseInputValueInteractor(
            service: service,
            presenter: presenter,
            orderModel: orderModel
        )
        let viewController = InsertValueTransferViewController(interactor: analytics, analytics: analytics)
        coordinator.viewController = viewController
        presenter.viewController = viewController
        analytics.interactor = interactor
        return viewController
    }
}
