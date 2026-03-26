import UIKit

enum PurchaseListAction: Equatable {
    case detail(offerId: String, productId: String, productTypeId: String)
}

protocol PurchaseListCoordinating: AnyObject {
    func perform(action: PurchaseListAction)
}

final class PurchaseListCoordinator {
    typealias Dependencies = HasDeeplinkOpener
    private let dependencies: Dependencies

    weak var viewController: UIViewController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - RoyaltyListCoordinating
extension PurchaseListCoordinator: PurchaseListCoordinating {
    func perform(action: PurchaseListAction) {
        switch action {
            case let .detail(offerId, productId, productTypeId):
                // Include productTypeId in the deeplink URL
                print("🔗 PurchaseListCoordinator creating deeplink:")
                print("   offerId: \(offerId)")
                print("   productId: \(productId)")
                print("   productTypeId: \(productTypeId)")
                
                let deeplinkString = "\(DeeplinkConfig.baseURL)purchase/offer/\(productId)/\(offerId)?productId=\(productId)&offerId=\(offerId)&productTypeId=\(productTypeId)"
                print("   Deeplink: \(deeplinkString)")
                
                guard let url = URL(string: deeplinkString) else {
                    print("❌ Failed to create URL from: \(deeplinkString)")
                    return
                }
                dependencies.deeplinkOpener.open(url: url)
        }
    }
}
