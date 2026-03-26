import Foundation

protocol PurchaseDetailInteracting: AnyObject {
    func fetchData()
    func didConfirm()
    func openDocument(urlString: String)
}

final class PurchaseDetailInteractor {
    // MARK: - Properties
    typealias Dependencies = HasAnalytics
    private let dependencies: Dependencies

    private let service: PurchaseDetailServicing
    private let presenter: PurchaseDetailPresenting
    private var model: PurchaseProductModel?
    private let productId: String
    private let offerId: String
    private let productTypeId: String?

    // MARK: - Initialize
    init(
        offerId: String,
        productId: String,
        productTypeId: String?,
        service: PurchaseDetailServicing,
        presenter: PurchaseDetailPresenting,
        dependencies: Dependencies
    ) {
        self.offerId = offerId
        self.productId = productId
        self.productTypeId = productTypeId
        self.service = service
        self.presenter = presenter
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseDetailInteracting
extension PurchaseDetailInteractor: PurchaseDetailInteracting {
    func fetchData() {
        presenter.startLoading()
        service.getOffer(
            productId: productId,
            offerId: offerId,
            productTypeId: productTypeId
        ) { [weak self] result in
            switch result {
                case .success(let model):
                    self?.model = model.data
                    self?.presenter.present(model: model.data)
                case .failure(let error):
                    self?.presenter.presentError(error)
            }
            self?.presenter.stopLoading()
        }
    }

    func didConfirm() {
        guard let model = model else { return }
        presenter.presentInputValueScreen(
            model: .init(
                offerId: offerId,
                productId: productId,
                value: 0,
                quantity: 0,
                tokenValue: 0,
                typeName: model.product.name.value,
                productName: model.name.value
            )
        )
    }

    func openDocument(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        presenter.presentDocument(url: url)
    }
}
