// MARK: - TEMPORARILY COMMENTED OUT - Focus on Welcome screen only
#if false
// import Core // Commented out - replaced with mock implementation
import Foundation
// import CoreNetworkingInterface // Commented out - replaced with mock implementation

final class PurchaseOrderDetailService {
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
extension PurchaseOrderDetailService: PurchaseDetailServicing {
    func getOffer(
        productId: String,
        offerId: String,
        completion: @escaping (Result<PurchaseDetailService.Response, ApiError>
        ) -> Void) {
        let endpoint = InvestmentsEndpoint.purchaseCustodyDetail(productId: productId, offerId: offerId)
        let decoder = JSONDecoder(.useDefaultKeys)
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] result in
            completion(result.mapError(\.apiError))
        }
    }
}
#endif
