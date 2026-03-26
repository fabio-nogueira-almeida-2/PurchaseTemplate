import Foundation

protocol PurchaseDetailServicing {
    func getOffer(
        productId: String,
        offerId: String,
        productTypeId: String?,
        completion: @escaping (Result<PurchaseDetailService.Response, ApiError>
        ) -> Void)
}

final class PurchaseDetailService {
    struct Response: Decodable, Equatable {
        let data: PurchaseProductModel
    }

    private let service: CoreServicing
    private var task: URLSessionTask?

    init(service: CoreServicing) {
        self.service = service
    }
}

// MARK: - PurchaseDetailServicing
extension PurchaseDetailService: PurchaseDetailServicing {
    func getOffer(
        productId: String,
        offerId: String,
        productTypeId: String?,
        completion: @escaping (Result<PurchaseDetailService.Response, ApiError>
        ) -> Void) {
        let endpoint = InvestmentsEndpoint.purchaseOfferDetail(productId: productId, offerId: offerId)
        let decoder = JSONDecoder.useDefaultKeys()
        
        // Store productTypeId for mock service to use
        if let productTypeId = productTypeId {
            let key = "\(productId):\(offerId)"
            MockCoreService.shared.setProductTypeId(productTypeId, for: key)
        }
        
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<PurchaseDetailService.Response, Error>) in
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
