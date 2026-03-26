import UIKit

protocol PurchaseCustodyDisplaying: AnyObject {
    func starLoading()
    func stopLoading()
    func display(dto: PurchaseCustodyDTO)
    func displayFeedback(feedback: InvestmentsHubFeedback)
}

final class PurchaseCustodyViewController: UIViewController, LoadingViewProtocol {
    lazy var loadingView = LoadingView()
    
    private let interactor: PurchaseCustodyInteracting
    private let customView = PurchaseCustodyView()
    private var filterTypeSelected: PurchaseCustodyView.FilterType?
    
    init(interactor: PurchaseCustodyInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        didSelect(type: .order)
    }
    
    private func setupUI() {
        customView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "questionmark.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapFaqBarButton)
        )
    }
    
    @objc
    func didTapFaqBarButton() {
        interactor.didTapFAQButton()
    }
}

// MARK: - PurchaseCustodyDisplaying
extension PurchaseCustodyViewController: PurchaseCustodyDisplaying {
    func display(dto: PurchaseCustodyDTO) {
        customView.setup(dto: dto)
        title = dto.title
    }
    
    func starLoading() {
        beginState()
    }
    
    func stopLoading() {
        endState()
    }
    
    func displayFeedback(feedback: InvestmentsHubFeedback) {
        if feedback == .connectionFailureError {
            showConnectionError(with: feedback) { [weak self] in
                self?.didSelect(type: self?.filterTypeSelected ?? .order)
            }
        } else {
            showGenericError(with: feedback)
        }
    }
}

extension PurchaseCustodyViewController: PurchaseCustodyViewDelegate {
    func didSelect(type: PurchaseCustodyView.FilterType) {
        filterTypeSelected = type
        switch type {
        case .order:
            interactor.fetchOrder()
        case .custody:
            interactor.fetchCustody()
        case .all:
            break
        }
    }
    
    func investAction() {
        interactor.didTapInvestButton()
    }
    
    func didSelect(index: Int) {
        interactor.didSelect(index: index)
    }
}

// MARK: - Error Handling Extensions
extension PurchaseCustodyViewController {
    func showConnectionError(with feedback: InvestmentsHubFeedback, retry: @escaping () -> Void) {
        let alert = UIAlertController(title: "Connection Error", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            retry()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func showGenericError(with feedback: InvestmentsHubFeedback) {
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

