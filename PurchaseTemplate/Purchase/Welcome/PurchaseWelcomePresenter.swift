// import Core // Commented out - replaced with mock implementation
// import AssetsKit // Commented out - replaced with mock implementation
// import UI // Commented out - replaced with mock implementation
import UIKit
import Foundation

protocol PurchaseWelcomePresenting: AnyObject {
    func present(model: PurchaseWelcomeServicingModel.PurchaseWelcomeModel)
    func openDeeplink(url: URL)
    func openWebView(url: URL)
    func presentError(_ error: ApiError)
    func startLoading()
    func stopLoading()
    func presentMaintenanceScreen()
}

final class PurchaseWelcomePresenter {
    private let coordinator: PurchaseWelcomeCoordinating
    weak var viewController: PurchaseWelcomeDisplaying?

    init(coordinator: PurchaseWelcomeCoordinating) {
        self.coordinator = coordinator
    }

    // MARK: - Private
    private func createDTO(with model: PurchaseWelcomeServicingModel.PurchaseWelcomeModel) -> PurchaseWelcomeDTO {
        let header = PurchaseWelcomeDTO.Header(
            title: .init(stringToken: model.name),
            description: .init(stringToken: model.description ),
            imageUrl: model.imageUrl
        )
        let items = model.items.map { data in
            PurchaseWelcomeDTO.ListItem(
                icon: data.imageIcon,
                title: .init(stringToken: data.name),
                description: .init(stringToken: data.description)
            )
        }
        let confirmButton = PurchaseWelcomeDTO.ActionButton(
            label: model.nextDeepLinkName.value,
            style: PurchaseWelcomeDTO.ActionButton.Style(rawValue: model.nextDeepLinkName.style) ?? .PrimaryMedium,
            action: model.nextDeepLink
        )
        let footer = PurchaseWelcomeDTO.Footer(tipText: Strings.Purchase.Welcome.tip, button: confirmButton)
        return .init(header: header, listItems: items, footer: footer)
    }
}

// MARK: - PurchaseWelcomePresenting
extension PurchaseWelcomePresenter: PurchaseWelcomePresenting {
    func present(model: PurchaseWelcomeServicingModel.PurchaseWelcomeModel) {
        let dto = createDTO(with: model)
        viewController?.display(dto: dto)
    }

    func openDeeplink(url: URL) {
        coordinator.openDeeplink(url: url)
    }

    func openWebView(url: URL) {
        coordinator.openWebView(url: url)
    }

    func presentError(_ error: ApiError) {
        viewController?.displayFeedback(feedback: error.feedback)
    }

    func presentMaintenanceScreen() {
        viewController?.displayFeedback(feedback: .maintenanceError)
    }

    func startLoading() {
        viewController?.starLoading()
    }

    func stopLoading() {
        viewController?.stopLoading()
    }
}
