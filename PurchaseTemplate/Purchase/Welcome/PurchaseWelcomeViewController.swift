import UI
import Apollo

struct PurchaseWelcomeDTO: Equatable {
    let header: Header
    let listItems: [ListItem]
    let footer: Footer

    struct Header: Equatable {
        let title: StringWithTypograph
        let description: StringWithTypograph
        let imageUrl: String
    }

    struct ListItem: Equatable {
        let icon: String
        let title: StringWithTypograph
        let description: StringWithTypograph
    }

    struct Footer: Equatable {
        let tipText: String
        let button: ActionButton
    }

    struct ActionButton: Equatable {
        let label: String
        let style: Style
        let action: String

        enum Style: String {
            case PrimaryMedium
            case SecondaryMedium
            case TertiaryMedium

            func style() -> Button.Style {
                switch self {
                case .PrimaryMedium:
                    return .primary
                case .SecondaryMedium:
                    return .secondary
                case .TertiaryMedium:
                    return .tertiary
                }
            }
        }
    }
}

protocol PurchaseWelcomeDisplaying: AnyObject {
    func display(dto: PurchaseWelcomeDTO)
    func displayFeedback(feedback: InvestmentsHubFeedback)
    func starLoading()
    func stopLoading()
}

final class PurchaseWelcomeViewController: ViewController<PurchaseWelcomeInteracting, UIView> {
    // MARK: - View
    private lazy var containerView = PurchaseWelcomeView()

    private lazy var closeButton = UIBarButtonBuilder.close { [weak self] in
        self?.navigationController?.popViewController(animated: true)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadWelcomeData()
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItems = [closeButton.build()]
    }

    override func buildViewHierarchy() {
        view.addSubview(containerView)
    }

    override func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// PurchaseWelcomeDisplaying
extension PurchaseWelcomeViewController: PurchaseWelcomeDisplaying {
    func display(dto: PurchaseWelcomeDTO) {
        containerView.setup(dto: dto)
        containerView.confirmButtonAction = { [weak self] in
            self?.interactor.handleDeeplink(urlString: dto.footer.button.action)
        }
    }

    func displayFeedback(feedback: InvestmentsHubFeedback) {
        if feedback == .connectionFailureError {
            showConnectionError(with: feedback) {[weak self] in
                self?.interactor.loadWelcomeData()
            }
        } else {
            showGenericError(with: feedback)
        }
    }

    func starLoading() {
        beginState()
    }

    func stopLoading() {
        endState()
    }
}

// MARK: - StatefulTransitionViewing
extension PurchaseWelcomeViewController: StatefulTransitionViewing {
    func statefulViewForLoading() -> StatefulViewing {
        PurchaseWelcomeSkeletonView()
    }
}
