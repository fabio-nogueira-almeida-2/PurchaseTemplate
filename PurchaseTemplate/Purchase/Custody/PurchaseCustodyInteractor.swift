import Core
import CoreTrackingInterface

protocol PurchaseCustodyInteracting: AnyObject {
    func fetchCustody()
    func fetchOrder()
    func fetchAll()
    func didTapInvestButton()
    func didSelect(index: Int)
    func didTapFAQButton()
}

final class PurchaseCustodyInteractor {
    // MARK: - Properties
    typealias Dependencies = HasAnalytics & HasDispatchGroup
    private let dependencies: Dependencies

    private let service: PurchaseCustodyServicing
    private let presenter: PurchaseCustodyPresenting
    private let productId: String
    private var positionResponse: PurchaseCustodyService.PositionResponse?
    private var orderResponse: PurchaseCustodyService.Response?

    // MARK: - Initialize
    init(
        service: PurchaseCustodyServicing,
        presenter: PurchaseCustodyPresenting,
        dependencies: Dependencies,
        productId: String
    ) {
        self.service = service
        self.presenter = presenter
        self.dependencies = dependencies
        self.productId = productId
    }

    // MARK: - Private
    func requestOrderWithoutRequestPosition() {
        presenter.startLoading()
        service.getOrder(productId: productId) { [weak self] result in
            guard
                let self = self,
                let position = positionResponse else {
                return
            }
            switch result {
                case .success(let response):
                    orderResponse = response
                    presenter.present(
                        order: response.data,
                        position: position.data.total
                    )
                case .failure(let error):
                    presenter.presentError(error)
            }
            presenter.stopLoading()
        }
    }

    func requestOrderAndPosition() {
        dependencies.dispatchGroup.enter()
        service.getPosition(productId: productId) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    positionResponse = response
                case .failure(let error):
                    presenter.presentError(error)
            }
            dependencies.dispatchGroup.leave()
        }

        dependencies.dispatchGroup.enter()
        service.getOrder(productId: productId) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    orderResponse = response
                case .failure(let error):
                    presenter.presentError(error)
            }
            dependencies.dispatchGroup.leave()
        }
    }

    func fetchOrderAndPosition() {
        presenter.startLoading()
        requestOrderAndPosition()
        dependencies.dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard
                let position = positionResponse,
                let order = orderResponse
            else {
                return
            }
            presenter.present(
                order: order.data,
                position: position.data.total
            )
            presenter.stopLoading()
        }
    }
}

// MARK: - PurchaseCustodyInteracting
extension PurchaseCustodyInteractor: PurchaseCustodyInteracting {
    func fetchAll() {}

    func fetchCustody() {
        presenter.startLoading()
        service.getCustody(productId: productId) { [weak self] result in
            guard
                let self = self,
                let position = positionResponse?.data.total else {
                return
            }
            switch result {
                case .success(let response):
                    presenter.present(
                        custody: response.data,
                        position: position
                    )
                case .failure(let error):
                    presenter.presentError(error)
            }
            presenter.stopLoading()
        }
    }

    func fetchOrder() {
        if positionResponse == nil {
            fetchOrderAndPosition()
        } else {
            requestOrderWithoutRequestPosition()
        }
    }

    func didTapInvestButton() {
        presenter.presentCatalog(id: productId)
    }

    func didSelect(index: Int) {
        presenter.presentDetailForItem(index: index)
    }

    func didTapFAQButton() {
        presenter.presentFAQ()
    }
}
