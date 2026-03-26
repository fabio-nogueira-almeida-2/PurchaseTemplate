import UIKit
import WebViewKitInterface

protocol PurchaseDetailCoordinating: AnyObject {
    func showInputValueScreen(model: PurchaseOrderModel)
    func openDocument(url: URL)
}

final class PurchaseDetailCoordinator {
    typealias Dependencies = HasWebViewFactory
    private let dependencies: Dependencies

    weak var viewController: UIViewController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseDetailCoordinating
extension PurchaseDetailCoordinator: PurchaseDetailCoordinating {
    func showInputValueScreen(model: PurchaseOrderModel) {
        let inputValueViewController = PurchaseInputValueFactory.make(orderModel: model)
        let navigationController = UINavigationController(rootViewController: inputValueViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true)
    }

    func openDocument(url: URL) {
        let properties = WebViewProperties()
        let webView = dependencies.webView.make(with: url, properties: properties)
        viewController?.navigationController?.pushViewController(webView, animated: true)
    }
}
