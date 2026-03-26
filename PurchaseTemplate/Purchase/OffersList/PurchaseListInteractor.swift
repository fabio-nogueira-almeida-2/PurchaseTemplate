import Core
import CoreTrackingInterface

protocol PurchaseListInteracting: AnyObject {
    func fetchData()
    func didSelect(index: Int)
}

final class PurchaseListInteractor {
    // MARK: - Properties
    typealias Dependencies = HasAnalytics
    private let dependencies: Dependencies

    private let service: PurchaseListServicing
    private let presenter: PurchaseListPresenting
    private let productId: String
    private let productTypeId: String

    // MARK: - Initialize
    init(
        service: PurchaseListServicing,
        presenter: PurchaseListPresenting,
        dependencies: Dependencies,
        productId: String,
        productTypeId: String
    ) {
        self.service = service
        self.presenter = presenter
        self.dependencies = dependencies
        self.productId = productId
        self.productTypeId = productTypeId
    }
}

// MARK: - PurchaseListInteracting
extension PurchaseListInteractor: PurchaseListInteracting {
    func fetchData() {
        presenter.startLoading()
        service.getOffers(productId: productId,
                          productTypeId: productTypeId) { [weak self] result in
            switch result {
            case .success(let model):
                self?.presenter.present(model: model.data)
            case .failure(let error):
                self?.handleError(error: error)
            }
            self?.presenter.stopLoading()
        }
    }

    func didSelect(index: Int) {
        presenter.presentDetailForItem(index: index)
    }
}

// MARK: - Private Extension
private extension PurchaseListInteractor {
    func handleError(error: ApiError) {
        presenter.presentError(error)
    }
}
