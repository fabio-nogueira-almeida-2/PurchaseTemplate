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
    private var task: URLSessionTask?
    
    // MARK: - Initialize
    init() {}
}

// MARK: - PurchaseCustodyServicing
extension PurchaseCustodyService: PurchaseCustodyServicing {
    func getPosition(productId: String, completion: @escaping (Result<PurchaseCustodyService.PositionResponse, ApiError>) -> Void) {
        JSONService.shared.loadJSONWithDelay(
            filename: "purchase_custody_position",
            type: PurchaseCustodyService.PositionResponse.self,
            delay: 1.0,
            completion: completion
        )
    }
    
    func getCustody(productId: String, completion: @escaping (Result<PurchaseCustodyService.Response, ApiError>) -> Void) {
        JSONService.shared.loadJSONWithDelay(
            filename: "purchase_custody_custody",
            type: PurchaseCustodyService.Response.self,
            delay: 1.0,
            completion: completion
        )
    }
    
    func getOrder(productId: String, completion: @escaping (Result<PurchaseCustodyService.Response, ApiError>) -> Void) {
        JSONService.shared.loadJSONWithDelay(
            filename: "purchase_custody_orders",
            type: PurchaseCustodyService.Response.self,
            delay: 1.0,
            completion: completion
        )
    }
}

