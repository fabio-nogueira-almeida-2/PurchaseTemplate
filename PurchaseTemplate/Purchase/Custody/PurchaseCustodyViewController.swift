import Apollo
import UI

protocol PurchaseCustodyDisplaying: AnyObject {
    func starLoading()
    func stopLoading()
    func display(dto: PurchaseCustodyDTO)
    func displayFeedback(feedback: InvestmentsHubFeedback)
}

final class PurchaseCustodyViewController: ViewController<PurchaseCustodyInteracting, PurchaseCustodyView>, LoadingViewProtocol {
    lazy var loadingView = LoadingView()

    private var filterTypeSelected: PurchaseCustodyView.FilterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        didSelect(type: .order)
    }

    func addFAQButton() {
        let barButton = UIBarButtonItem(
            image: Icon.questionCircle.image,
            style: .plain,
            target: self,
            action: #selector(didTapFaqBarButton)
        )
        barButton.tintColor = Color.grayScale900.color
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
        rootView.delegate = self
        rootView.setup(dto: dto)
        title = dto.title
        addFAQButton()
    }

    func starLoading() {
        beginState()
    }

    func stopLoading() {
        endState()
    }

    func displayFeedback(feedback: InvestmentsHubFeedback) {
        if feedback == .connectionFailureError {
            showConnectionError(with: feedback) {[weak self] in
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

// MARK: - StatefulTransitionViewing
extension PurchaseCustodyViewController: StatefulTransitionViewing {
    func statefulViewForLoading() -> StatefulViewing {
        PurchaseListSkeletonView()
    }
}
