import Foundation

protocol PurchaseDetailServicing {
    func getDetail(completion: @escaping (Result<PurchaseDetailDTO, ApiError>) -> Void)
}

final class PurchaseDetailService: PurchaseDetailServicing {
    func getDetail(completion: @escaping (Result<PurchaseDetailDTO, ApiError>) -> Void) {
        JSONService.shared.loadJSONWithDelay(
            filename: "purchase_detail",
            type: PurchaseDetailDTO.self,
            delay: 1.0,
            completion: completion
        )
    }
}
