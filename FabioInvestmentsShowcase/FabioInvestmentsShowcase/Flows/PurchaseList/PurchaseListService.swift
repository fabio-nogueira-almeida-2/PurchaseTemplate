import Foundation

protocol PurchaseListServicing {
    func getList(completion: @escaping (Result<PurchaseListDTO, ApiError>) -> Void)
}

final class PurchaseListService: PurchaseListServicing {
    func getList(completion: @escaping (Result<PurchaseListDTO, ApiError>) -> Void) {
        JSONService.shared.loadJSONWithDelay(
            filename: "purchase_list",
            type: PurchaseListDTO.self,
            delay: 1.0,
            completion: completion
        )
    }
}
