import UIKit

enum PurchaseInputValueFactory {
    static func make(orderModel: PurchaseOrderModel) -> UIViewController {
        let dependencies = DependencyContainer()
        let service = PurchaseInputValueService(service: dependencies.coreService)
        let coordinator = PurchaseInputValueCoordinator(dependencies: HasNoDependencyImpl())
        let presenter = PurchaseInputValuePresenter(coordinator: coordinator)
        let interactor = PurchaseInputValueInteractor(
            service: service,
            presenter: presenter,
            orderModel: orderModel
        )
        let analytics = InsertValueTransferAnalyticsImpl(type: .out, dependencies: dependencies)
        let viewController = InsertValueTransferViewController(interactor: interactor, analytics: analytics)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        analytics.interactor = interactor
        
        return viewController
    }
}
