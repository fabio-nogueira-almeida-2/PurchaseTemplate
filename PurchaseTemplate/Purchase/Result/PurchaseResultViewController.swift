import UIKit

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
        let view = Avatar()
        view.image = UIImage(systemName: "checkmark.circle.fill")
        view.backgroundColor = Color.primary500.uiColor
        view.tintColor = .white
        return view
    }()

    lazy var titleText: Text = {
        let view = Text()
        view.font(Font.medium)
        view.value = strings.title
        view.textAlignment = .center
        return view
    }()

    lazy var detailText: Text = {
        let view = Text()
        view.font(Font.body)
        view.foreground(color: .grayScale900)
        view.textAlignment = .center
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
        view.backgroundColor = .white
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
            $0.top.equalToSuperview().inset(Space.base08.rawValue)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        titleText.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(Space.base04.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }
        detailText.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(Space.base04.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }
        primaryButton.snp.makeConstraints {
            $0.top.equalTo(detailText.snp.bottom).offset(Space.base08.rawValue)
            $0.height.equalTo(CGFloat(Layout.Size.buttonHeight))
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }
        secondaryButton.snp.makeConstraints {
            $0.top.equalTo(primaryButton.snp.bottom).offset(Space.base04.rawValue)
            $0.height.equalTo(CGFloat(Layout.Size.buttonHeight))
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base04.rawValue)
        }
    }
}

extension PurchaseResultViewController: PurchaseResultDisplaying {
}
