import Core
import CoreNetworkingInterface

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
        task = service.request(endpoint: endpoint) { [weak self] result in
            guard self != nil else { return }
            completion(result.mapError(\.apiError))
        }
    }
}
