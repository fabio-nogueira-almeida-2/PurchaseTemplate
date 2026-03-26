import UIKit

protocol PurchaseCustodyDisplaying: AnyObject {
    func starLoading()
    func stopLoading()
    func display(dto: PurchaseCustodyDTO)
    func displayFeedback(feedback: InvestmentsHubFeedback)
}

final class PurchaseCustodyViewController: ViewController<PurchaseCustodyInteracting, PurchaseCustodyView> {
    private var filterTypeSelected: PurchaseCustodyView.FilterType?
    private lazy var rootView = PurchaseCustodyView()
    
    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Default to order filter - this will call fetchOrder()
        // For catalog interactor, fetchOrder() calls fetchData() which loads all investments
        didSelect(type: .order)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Don't force layout here - wait until view is fully in hierarchy
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Reload tables now that view is definitely in the hierarchy
        // This is the safest place to reload - view is fully visible and in window
        rootView.reloadTablesIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Don't reload here - viewDidLayoutSubviews can be called before view is in window
        // Only reload in viewDidAppear where we're guaranteed the view is in the hierarchy
    }

    func addFAQButton() {
        let barButton = UIBarButtonItem(
            image: Icon.questionmarkCircle.image,
            style: .plain,
            target: self,
            action: #selector(didTapFaqBarButton)
        )
        barButton.tintColor = Color.grayScale900.uiColor
        navigationItem.rightBarButtonItem = barButton
    }

    @objc
    func didTapFaqBarButton() {
        interactor.didTapFAQButton()
    }
}

// MARK: - PurchaseCustodyDisplaying
extension PurchaseCustodyViewController: PurchaseCustodyDisplaying {
    func display(dto: PurchaseCustodyDTO) {
        print("📱 PurchaseCustodyViewController.display() called with \(dto.cards.count) cards")
        rootView.delegate = self
        rootView.setup(dto: dto)
        title = dto.title
        addFAQButton()
        
        // Don't force layout here - let viewWillAppear/viewDidAppear handle it
        // This prevents layout warnings when view is not yet in hierarchy
    }

    func starLoading() {
        // Show loading state
    }

    func stopLoading() {
        // Hide loading state
    }

    func displayFeedback(feedback: InvestmentsHubFeedback) {
        let message: String
        switch feedback {
        case .connectionFailureError:
            message = "Erro de conexão. Verifique sua internet e tente novamente."
        case .genericError:
            message = "Ocorreu um erro. Tente novamente mais tarde."
        case .maintenanceError:
            message = "Serviço em manutenção. Tente novamente mais tarde."
        }
        let alert = UIAlertController(
            title: "Erro",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            // fetchAll() will call fetchData() for catalog interactor
            interactor.fetchAll()
        }
    }

    func investAction() {
        interactor.didTapInvestButton()
    }

    func didSelect(index: Int) {
        interactor.didSelect(index: index)
    }
}
