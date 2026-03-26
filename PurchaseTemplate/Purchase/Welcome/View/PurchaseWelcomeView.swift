// import Apollo // Commented out - replaced with mock implementation
// import UI // Commented out - replaced with mock implementation
import UIKit

final class PurchaseWelcomeView: UIView, ViewConfiguration {
    typealias Localizable = Strings.Purchase.Welcome

    enum Layout {
        enum Size {
            static let image: CGFloat = 16
            static let button: CGFloat = 48
        }
    }

    // MARK: - View
    lazy var scrollView = UIScrollView()

    lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.base03.rawValue
        view.distribution = .fill
        return view
    }()

    lazy var footerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.base03.rawValue
        view.distribution = .fill
        view.layoutMargins = EdgeInsets.rootView
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()

    lazy var titleText: Text = {
        let view = Text()
        view.font(Font.medium)
        view.bold()
        view.numberOfLines = 0
        return view
    }()

    lazy var descriptionText: Text = {
        let view = Text()
        view.font(Font.note)
        view.foreground(color: .grayScale800)
        view.numberOfLines = 0
        return view
    }()

    // MARK: - Properties
    let strings = Strings.Royalty.self
    var confirmButtonAction: (() -> Void)?

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(scrollView)
        addSubview(footerStackView)
        scrollView.addSubview(containerStackView)
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(footerStackView.snp.top)
        }
        footerStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        containerStackView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            // Constrain width to scrollView width minus insets to prevent horizontal scrolling
            // Use offset before equalTo to subtract from the width
            let insetValue = Space.base04.rawValue * 2
            $0.width.offset(-insetValue).equalTo(scrollView.snp.width)
        }
    }

    func configureViews() {
        background(color: .white)
    }
}

extension PurchaseWelcomeView {
    func setup(dto: PurchaseWelcomeDTO) {
        // Clear existing arranged subviews before adding new ones
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        footerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        setupHeader(dto: dto.header)
        setupListItems(dto: dto.listItems)
        setupFooter(dto: dto.footer)
    }

    private func setupHeader(dto: PurchaseWelcomeDTO.Header) {
        let headerImageView = PurchaseWelcomeHeaderImageView()
        headerImageView.setup(imageUrl: dto.imageUrl)
        containerStackView.addArrangedSubview(headerImageView)

        titleText.value = dto.title.value
        titleText.setTypograph(dto.title.typograph)
        containerStackView.addArrangedSubview(titleText)

        descriptionText.value = dto.description.value
        descriptionText.setTypograph(dto.description.typograph)
        containerStackView.addArrangedSubview(descriptionText)
    }

    private func setupListItems(dto: [PurchaseWelcomeDTO.ListItem]) {
        dto.forEach { item in
            let card = PurchaseWelcomeCardView(
                text: item.title,
                description: item.description,
                icon: Icon(rawValue: item.icon) ?? .infoCircle
            )
            containerStackView.addArrangedSubview(card)
        }
    }

    private func setupFooter(dto: PurchaseWelcomeDTO.Footer) {
        let tipView = PurchaseWelcomeFeedbackView()
        tipView.titleText.value = dto.tipText
        let actionButton: Button = {
            Button(style: .primary, label: dto.button.label) {[weak self] in
                self?.confirmButtonAction?()
            }
        }()

        footerStackView.addArrangedSubview(tipView)
        footerStackView.addArrangedSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.height.equalTo(Layout.Size.button)
        }
    }
}
