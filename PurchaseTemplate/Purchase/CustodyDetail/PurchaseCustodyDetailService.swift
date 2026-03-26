import Core
import CoreNetworkingInterface

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
        completion: @escaping (Result<PurchaseDetailService.Response, ApiError>
        ) -> Void) {
        let endpoint = InvestmentsEndpoint.purchaseCustodyDetail(productId: productId, offerId: offerId)
        let decoder = JSONDecoder(.convertFromSnakeCase)
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] result in
            completion(result.mapError(\.apiError))
        }
    }
}
