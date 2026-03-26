import Core
import CoreNetworkingInterface

protocol PurchaseWelcomeServicing {
    typealias Response = PurchaseWelcomeServicingModel.Response
    func getWelcomeData(productId: String,
                        productTypeId: String,
                        completion: @escaping (Result<Response, ApiError>) -> Void)
}

enum PurchaseWelcomeServicingModel {
    struct Response: Decodable, Equatable {
        let data: PurchaseWelcomeModel
    }

    struct PurchaseWelcomeModel: Decodable, Equatable {
        let productId: Int
        let productTypeId: Int
        let name: StringToken
        let description: StringToken
        let nextDeepLinkName: StringToken
        let nextDeepLink: String
        let imageUrl: String
        let items: [MenuItem]
    }

    struct MenuItem: Decodable, Equatable {
        let name: StringToken
        let description: StringToken
        let nextDeepLink: String
        let imageIcon: String
    }
}

public struct StringToken: Decodable, Equatable {
    let value: String
    let style: String
}

final class PurchaseWelcomeService {
    private let service: CoreServicing
    private var task: URLSessionTask?

    init(service: CoreServicing) {
        self.service = service
    }
}

// MARK: - PurchaseWelcomeServicing
extension PurchaseWelcomeService: PurchaseWelcomeServicing {
    func getWelcomeData(productId: String,
                        productTypeId: String,
                        completion: @escaping (Result<Response, ApiError>) -> Void) {
        let endpoint: InvestmentsEndpoint = .purchaseWelcome(productId: productId,
                                                             productTypeId: productTypeId)
        let decoder = JSONDecoder(.useDefaultKeys)
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] result in
            completion(result.mapError(\.apiError))
        }
    }
}
