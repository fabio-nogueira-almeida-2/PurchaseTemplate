import Foundation

protocol PurchaseConfirmationInteracting: AnyObject {
    func fetchData()
    func didConfirm()
}

final class PurchaseConfirmationInteractor {
    // MARK: - Properties
    typealias Dependencies = HasAuth
    private let dependencies: Dependencies

    private let service: PurchaseConfirmationServicing
    private let presenter: PurchaseConfirmationPresenting

    private let model: PurchaseOrderModel

    // MARK: - Initialize
    init(
        service: PurchaseConfirmationServicing,
        presenter: PurchaseConfirmationPresenting,
        dependencies: Dependencies,
        model: PurchaseOrderModel) {
            self.service = service
            self.presenter = presenter
            self.dependencies = dependencies
            self.model = model
        }

    // MARK: - Private
    private func confirmTransfer() {
        dependencies.auth.authenticate { [weak self] resultAuth in
            guard let self else { return }
            switch resultAuth {
            case let .success(pin):
                requestTransaction(pin: pin)
            case .failure:
                    break
            }
        }
    }

    private func requestTransaction(pin: String) {
        presenter.startLoading()
        let request = PurchaseOrderRequest(value: model.value, amount: nil)
        service.request(
            productId: model.productId,
            offerId: model.offerId,
            model: request
        ) { [weak self] result in
            self?.presenter.stopLoading()
            switch result {
            case .success:
                    self?.presenter.didNextStep(action: .result(self?.model.productId ?? ""))
            case .failure(let error):
                self?.presenter.presentError(error)
            }
        }
    }
}

// MARK: - PurchaseConfirmationInteracting
extension PurchaseConfirmationInteractor: PurchaseConfirmationInteracting {
    func fetchData() {
        presenter.display(model)
    }

    func didConfirm() {
        confirmTransfer()
    }
}
