import Foundation

protocol PurchaseCatalogInteracting: AnyObject {
    func fetchData()
    func didSelect(index: Int)
}

// Make PurchaseCatalogInteractor compatible with PurchaseCustodyInteracting
extension PurchaseCatalogInteractor: PurchaseCustodyInteracting {}

final class PurchaseCatalogInteractor {
    // MARK: - Properties
    typealias Dependencies = HasAnalytics
    private let dependencies: Dependencies

    private let service: PurchaseCatalogServicing
    private let presenter: PurchaseCatalogPresenting
    private var catalogData: [PurchaseProductModel]?

    // MARK: - Initialize
    init(
        service: PurchaseCatalogServicing,
        presenter: PurchaseCatalogPresenting,
        dependencies: Dependencies
    ) {
        self.service = service
        self.presenter = presenter
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseCatalogInteracting
extension PurchaseCatalogInteractor: PurchaseCatalogInteracting {
    func fetchData() {
        presenter.startLoading()
        service.getCatalog { [weak self] result in
            switch result {
            case .success(let model):
                print("✅ Catalog data loaded successfully: \(model.data.count) items")
                self?.catalogData = model.data
                self?.presenter.present(model: model.data)
            case .failure(let error):
                print("❌ Catalog error: \(error)")
                self?.handleError(error: error)
            }
            self?.presenter.stopLoading()
        }
    }

    func didSelect(index: Int) {
        presenter.presentDetailForItem(index: index)
    }
}

// MARK: - PurchaseCustodyInteracting
extension PurchaseCatalogInteractor {
    // For catalog, we show all investments when fetching order/custody
    func fetchOrder() {
        print("📋 Catalog: fetchOrder() called")
        fetchData()
    }
    
    func fetchCustody() {
        print("📋 Catalog: fetchCustody() called")
        fetchData()
    }
    
    func fetchAll() {
        print("📋 Catalog: fetchAll() called")
        fetchData()
    }
    
    func didTapInvestButton() {
        print("📋 Catalog: Invest button tapped")
        // For catalog, navigate to dashboard so user can select a specific investment type
        // Access via PurchaseCustodyPresenting protocol
        (presenter as? PurchaseCustodyPresenting)?.presentCatalog(id: "")
    }
    
    func didTapFAQButton() {
        // Handle FAQ navigation if needed
    }
}

// MARK: - Private Extension
private extension PurchaseCatalogInteractor {
    func handleError(error: ApiError) {
        presenter.presentError(error)
    }
}

