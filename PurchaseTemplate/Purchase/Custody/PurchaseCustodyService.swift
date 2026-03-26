import Foundation

protocol PurchaseCustodyServicing {
    func getCustody(productId: String, completion: @escaping (Result<PurchaseCustodyService.Response, ApiError>) -> Void)
    func getOrder(productId: String, completion: @escaping (Result<PurchaseCustodyService.Response, ApiError>) -> Void)
    func getPosition(productId: String, completion: @escaping (Result<PurchaseCustodyService.PositionResponse, ApiError>) -> Void)
}

final class PurchaseCustodyService {
    struct Response: Decodable, Equatable {
        let data: [PurchaseProductModel]
    }

    struct PositionResponse: Decodable, Equatable {
        let data: TotalPosition

        struct TotalPosition: Decodable, Equatable {
            let total: TotalPositionValue
        }

        struct TotalPositionValue: Decodable, Equatable {
            let value: Token
            let yield: Token

            struct Token: Decodable, Equatable {
                let label: StringToken
                let description: StringToken?
                let value: StringToken?
            }
        }
    }

    // MARK: - Properties
    private let service: CoreServicing
    private var task: URLSessionTask?

    // MARK: - Initialize
    init(service: CoreServicing) {
        self.service = service
    }
}

// MARK: - PurchaseCustodyServicing
extension PurchaseCustodyService: PurchaseCustodyServicing {
    func getPosition(productId: String, completion: @escaping (Result<PurchaseCustodyService.PositionResponse, ApiError>) -> Void) {
        let endpoint: InvestmentsEndpoint = .purchaseCustodyPosition(productId: productId)
        let decoder = JSONDecoder.useDefaultKeys()
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<PurchaseCustodyService.PositionResponse, Error>) in
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

    func getCustody(productId: String, completion: @escaping (Result<PurchaseCustodyService.Response, ApiError>) -> Void) {
        let endpoint: InvestmentsEndpoint = .purchaseCustody(productId: productId)
        let decoder = JSONDecoder.useDefaultKeys()
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<PurchaseCustodyService.Response, Error>) in
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

    func getOrder(productId: String, completion: @escaping (Result<PurchaseCustodyService.Response, ApiError>) -> Void) {
        let endpoint: InvestmentsEndpoint = .purchaseOrders(productId: productId)
        let decoder = JSONDecoder.useDefaultKeys()
        task = service.request(endpoint: endpoint, decoder: decoder) { [weak self] (result: Result<PurchaseCustodyService.Response, Error>) in
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
