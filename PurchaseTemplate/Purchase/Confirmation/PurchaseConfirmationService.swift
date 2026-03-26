import Foundation

protocol PurchaseConfirmationServicing {
    func request(
        productId: String,
        offerId: String,
        model: PurchaseOrderRequest,
        completion: @escaping (Result<Data, ApiError>) -> Void
    )
}

final class PurchaseConfirmationService {
    typealias Dependencies = HasConsumerManager
    private let dependencies: Dependencies
    private let service: CoreServicing
    private var task: URLSessionTask?
    
    init(service: CoreServicing, dependencies: Dependencies) {
        self.service = service
        self.dependencies = dependencies
    }
    
    deinit {
        task?.cancel()
    }
}

// MARK: - RoyaltyConfirmationServicing
extension PurchaseConfirmationService: PurchaseConfirmationServicing {
    func request(
        productId: String,
        offerId: String,
        model: PurchaseOrderRequest,
        completion: @escaping (Result<Data, ApiError>) -> Void
    ) {
        let consumerId = String(dependencies.consumerManager.consumerId)
        let endpoint = InvestmentsEndpoint.purchaseOrder(
            consumerId: consumerId,
            productId: productId,
            offerId: offerId,
            model: model
        )
        let decoder = JSONDecoder.useDefaultKeys()
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<Data, Error>) in
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
