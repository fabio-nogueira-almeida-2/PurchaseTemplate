import Foundation

protocol PurchaseDetailPresenting: AnyObject {
    func present(dto: PurchaseDetailDTO)
    func startLoading()
    func stopLoading()
    func presentError(_ error: ApiError)
    func presentConfirmation()
    func presentDocument(urlString: String)
}

final class PurchaseDetailPresenter {
    private let coordinator: PurchaseDetailCoordinating
    weak var viewController: PurchaseDetailDisplaying?
    
    init(coordinator: PurchaseDetailCoordinating) {
        self.coordinator = coordinator
    }
}

extension PurchaseDetailPresenter: PurchaseDetailPresenting {
    func present(dto: PurchaseDetailDTO) {
        viewController?.display(dto: dto)
    }
    
    func startLoading() {
        viewController?.startLoading()
    }
    
    func stopLoading() {
        viewController?.stopLoading()
    }
    
    func presentError(_ error: ApiError) {
        viewController?.displayFeedback(feedback: error.feedback)
    }
    
    func presentConfirmation() {
        coordinator.navigateToConfirmation()
    }
    
    func presentDocument(urlString: String) {
        coordinator.navigateToDocument(urlString: urlString)
    }
}

