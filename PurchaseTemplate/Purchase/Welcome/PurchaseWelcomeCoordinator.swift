import Core
import UIKit
import WebViewKitInterface

protocol HasNoDependency {}

protocol PurchaseWelcomeCoordinating: AnyObject {
    func openDeeplink(url: URL)
    func openWebView(url: URL)
}

final class PurchaseWelcomeCoordinator {
    typealias Dependencies = HasDeeplinkOpener & HasWebViewFactory
    private let dependencies: Dependencies

    weak var viewController: UIViewController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - PurchaseWelcomeCoordinating
extension PurchaseWelcomeCoordinator: PurchaseWelcomeCoordinating {
    func openDeeplink(url: URL) {
        dependencies.deeplinkOpener.open(url: url)
    }

    func openWebView(url: URL) {
        let properties = WebViewProperties()
        let webView = dependencies.webView.make(with: url, properties: properties) { [weak self] _ in
            self?.viewController?.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        viewController?.navigationController?.setNavigationBarHidden(true, animated: true)
        viewController?.navigationController?.pushViewController(webView, animated: true)
    }
}
