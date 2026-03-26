import Foundation

final class PurchaseCustodyDetailService {
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
extension PurchaseCustodyDetailService: PurchaseDetailServicing {
    func getOffer(
        productId: String,
        offerId: String,
        productTypeId: String? = nil,
        completion: @escaping (Result<PurchaseDetailService.Response, ApiError>) -> Void
    ) {
        let endpoint = InvestmentsEndpoint.purchaseCustodyDetail(productId: productId, offerId: offerId)
        let decoder = JSONDecoder.useDefaultKeys()
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<PurchaseCustodyDetailService.Response, Error>) in
            guard self != nil else { return }
            let mappedResult = result.map { response -> PurchaseDetailService.Response in
                // Convert PurchaseCustodyDetailService.Response to PurchaseDetailService.Response
                return PurchaseDetailService.Response(data: response.data)
            }.mapError { error -> ApiError in
                if let apiError = error as? ApiError {
                    return apiError
                }
                return ApiError.unknown
            }
            completion(mappedResult)
        }
    }
}
