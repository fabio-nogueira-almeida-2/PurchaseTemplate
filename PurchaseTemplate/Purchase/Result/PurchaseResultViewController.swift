import Apollo
import UI

extension PurchaseResultViewController.Layout {
    enum Size {
        static let buttonHeight = 48
    }
}

protocol PurchaseResultDisplaying: AnyObject {
}

final class PurchaseResultViewController: ViewController<PurchaseResultInteracting, UIView> {
    enum Layout {}

    // MARK: - View
    lazy var icon: Avatar = {
        let view = Avatar(icon: .check, size: .small, style: .circle)
        view.background(color: .primary500)
        view.foreground(color: .white)
        return view
    }()

    lazy var titleText: Text = {
        let view = Text()
        view.font(Font.medium)
        view.value = strings.title
        view.multilineTextAlignment(.center)
        return view
    }()

    lazy var detailText: Text = {
        let view = Text()
        view.font(Font.body)
        view.foreground(color: .grayScale900)
        view.multilineTextAlignment(.center)
        view.value = strings.detail
        return view
    }()

    lazy var primaryButton: Button = {
        Button(style: .primary, label: strings.primaryButton) { [weak self] in
            self?.interactor.primaryButtonAction()
        }
    }()

    lazy var secondaryButton: Button = {
        Button(style: .tertiary, label: strings.secondaryButton) { [weak self] in
            self?.interactor.secondaryButtonAction()
        }
    }()

    // MARK: - Properties
    private let strings = Strings.Royalty.Result.self

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        view.background(color: .white)
    }

    // MARK: - ViewConfiguration
    override func buildViewHierarchy() {
        view.addSubview(icon)
        view.addSubview(titleText)
        view.addSubview(detailText)
        view.addSubview(primaryButton)
        view.addSubview(secondaryButton)
    }

    override func setupConstraints() {
        icon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        titleText.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(Space.base02.rawValue)
            $0.leading.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
        detailText.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(Space.base01.rawValue)
            $0.centerY.equalToSuperview().offset(-Space.base06.rawValue)
            $0.leading.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
        primaryButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(detailText.snp.bottom)
            $0.height.equalTo(Layout.Size.buttonHeight)
            $0.leading.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
        secondaryButton.snp.makeConstraints {
            $0.top.equalTo(primaryButton.snp.bottom).offset(Space.base02.rawValue)
            $0.height.equalTo(Layout.Size.buttonHeight)
            $0.leading.trailing.equalToSuperview().inset(Space.base02.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base04.rawValue)
        }
    }
}

extension PurchaseResultViewController: PurchaseResultDisplaying {
}
