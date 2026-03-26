import UIKit

enum PurchaseListAction: Equatable {
    case detail(offerId: String, productId: String, productTypeId: String)
}

protocol PurchaseListCoordinating: AnyObject {
    func perform(action: PurchaseListAction)
}

final class PurchaseListCoordinator {
    private let dependencies: ModuleDependencies

    weak var viewController: UIViewController?

    init(dependencies: ModuleDependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - RoyaltyListCoordinating
extension PurchaseListCoordinator: PurchaseListCoordinating {
    func perform(action: PurchaseListAction) {
        switch action {
            case let .detail(offerId, productId, productTypeId):
                guard let url = URL(
                    string: InvestmentsDeeplinkPath.purchaseOfferDetail(
                        offerId: offerId,
                        productId: productId
                    ).asDeeplink
                ) else { return }
                dependencies.deeplinkOpener.open(url: url)
        }
    }
}
