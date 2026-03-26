import Foundation

protocol PurchaseListInteracting: AnyObject {
    func fetchData()
    func didSelect(index: Int)
}

final class PurchaseListInteractor {
    private let service: PurchaseListServicing
    private let presenter: PurchaseListPresenting
    
    init(service: PurchaseListServicing, presenter: PurchaseListPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

extension PurchaseListInteractor: PurchaseListInteracting {
    func fetchData() {
        presenter.startLoading()
        service.getList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                presenter.present(dto: response)
            case .failure(let error):
                presenter.presentError(error)
            }
            presenter.stopLoading()
        }
    }
    
    func didSelect(index: Int) {
        presenter.presentDetail(index: index)
    }
}
