import Foundation

protocol PurchaseCatalogServicing {
    func getCatalog(completion: @escaping (Result<PurchaseCatalogService.Response, ApiError>) -> Void)
}

final class PurchaseCatalogService {
    struct Response: Decodable, Equatable {
        let data: [PurchaseProductModel]
    }

    private let service: CoreServicing
    private var task: URLSessionTask?
    private var isRequesting = false

    init(service: CoreServicing) {
        self.service = service
    }
}

// MARK: - PurchaseCatalogServicing
extension PurchaseCatalogService: PurchaseCatalogServicing {
    func getCatalog(completion: @escaping (Result<PurchaseCatalogService.Response, ApiError>) -> Void) {
        // Prevent duplicate requests
        guard !isRequesting else {
            print("⚠️ Catalog request already in progress, ignoring duplicate call")
            return
        }
        
        isRequesting = true
        let endpoint: InvestmentsEndpoint = .purchaseCatalog
        let decoder = JSONDecoder.useDefaultKeys()
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<PurchaseCatalogService.Response, Error>) in
            guard let self = self else { return }
            self.isRequesting = false
            let mappedResult = result.mapError { error -> ApiError in
                if let apiError = error as? ApiError {
                    return apiError
                }
                return ApiError.unknown
            }
            completion(mappedResult)
        }
    }
}


