import Foundation

protocol PurchaseListPresenting: AnyObject {
    func present(dto: PurchaseListDTO)
    func startLoading()
    func stopLoading()
    func presentError(_ error: ApiError)
    func presentDetail(index: Int)
}

final class PurchaseListPresenter {
    private let coordinator: PurchaseListCoordinating
    weak var viewController: PurchaseListDisplaying?
    
    init(coordinator: PurchaseListCoordinating) {
        self.coordinator = coordinator
    }
}

extension PurchaseListPresenter: PurchaseListPresenting {
    func present(dto: PurchaseListDTO) {
        viewController?.display(dto: dto)
    }
    
    func startLoading() {
        viewController?.starLoading()
    }
    
    func stopLoading() {
        viewController?.stopLoading()
    }
    
    func presentError(_ error: ApiError) {
        viewController?.displayFeedback(feedback: error.feedback)
    }
    
    func presentDetail(index: Int) {
        coordinator.navigateToDetail(index: index)
    }
}
