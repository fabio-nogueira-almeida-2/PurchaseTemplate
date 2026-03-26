import Foundation

protocol PurchaseDetailInteracting: AnyObject {
    func fetchData()
    func didConfirm()
    func openDocument(urlString: String)
}

final class PurchaseDetailInteractor {
    private let service: PurchaseDetailServicing
    private let presenter: PurchaseDetailPresenting
    
    init(service: PurchaseDetailServicing, presenter: PurchaseDetailPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

extension PurchaseDetailInteractor: PurchaseDetailInteracting {
    func fetchData() {
        presenter.startLoading()
        service.getDetail { [weak self] result in
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
    
    func didConfirm() {
        presenter.presentConfirmation()
    }
    
    func openDocument(urlString: String) {
        presenter.presentDocument(urlString: urlString)
    }
}

