import Foundation

protocol PurchaseInputValueServicing {
    func getData(
        productId: String,
        offerId: String,
        completion: @escaping (Result<PurchaseInputValueService.Response, ApiError>) -> Void
    )
}

final class PurchaseInputValueService {
    struct Response: Decodable, Equatable {
        let data: PurchaseOrderRuleModel
    }

    private let service: CoreServicing
    private var task: URLSessionTask?

    init(service: CoreServicing) {
        self.service = service
    }

    deinit {
        task?.cancel()
    }
}

// MARK: - PurchaseInputValueServicing
extension PurchaseInputValueService: PurchaseInputValueServicing {
    func getData(
        productId: String,
        offerId: String,
        completion: @escaping (Result<PurchaseInputValueService.Response, ApiError>
        ) -> Void) {
        let endpoint = InvestmentsEndpoint.purchaseOrderRule(productId: productId, offerId: offerId)
        let decoder = JSONDecoder.useDefaultKeys()
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<PurchaseInputValueService.Response, Error>) in
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
