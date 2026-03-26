import Foundation

protocol PurchaseListServicing {
    func getOffers(productId: String,
                   productTypeId: String,
                   completion: @escaping (Result<PurchaseListService.Response, ApiError>) -> Void)
}

final class PurchaseListService {
    struct Response: Decodable, Equatable {
        let data: [PurchaseProductModel]
    }

    private let service: CoreServicing
    private var task: URLSessionTask?

    init(service: CoreServicing) {
        self.service = service
    }
}
// MARK: - PurchaseListServicing
extension PurchaseListService: PurchaseListServicing {
    func getOffers(productId: String,
                   productTypeId: String,
                   completion: @escaping (Result<PurchaseListService.Response, ApiError>) -> Void) {
        let endpoint: InvestmentsEndpoint = .purchaseOffers(productId: productId, productTypeId: productTypeId)
        let decoder = JSONDecoder.useDefaultKeys()
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<PurchaseListService.Response, Error>) in
            guard self != nil else { return }
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
