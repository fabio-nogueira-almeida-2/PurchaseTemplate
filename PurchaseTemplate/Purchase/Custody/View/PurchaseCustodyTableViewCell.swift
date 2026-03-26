// MARK: - TEMPORARILY COMMENTED OUT - Focus on Welcome screen only

// import Apollo // Commented out - replaced with mock implementation
import UIKit
// import UI // Commented out - replaced with mock implementation

extension PurchaseCustodyTableViewCell.Layout {
    enum Size {
        static let line = 1
        static let chipsHeight = 23
        static let arrow = 24
        static let buttonHeight = 48
    }
}

final class PurchaseCustodyTableViewCell: UITableViewCell, ViewConfiguration {
    enum Layout {}

    // MARK: - View
    private lazy var containerView: UIView = {
        let view = UIView()
        view.background(color: .background00)
        view.corner(radius: .large)
        return view
    }()

    private lazy var arrowView = UIImageView(image: Icon.angleRightB.image)

    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()

    private lazy var titleText: Text = {
        let view = Text()
        view.font(Font.label)
        view.foreground(color: .grayScale900)
        return view
    }()

    private lazy var descriptionText: Text = {
        let view = Text()
        view.font(Font.body)
        view.foreground(color: .grayScale900)
        view.bold()
        return view
    }()

    lazy var infoChips = PurchaseLabelChipsView()

    private lazy var costStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()

    private lazy var costTitleText: Text = {
        let view = Text()
        view.font(Font.label)
        view.foreground(color: .grayScale800)
        return view
    }()

    private lazy var costValueText: Text = {
        let view = Text()
        view.font(Font.body)
        view.foreground(color: .grayScale900)
        view.bold()
        return view
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.background(color: .grayScale200)
        return view
    }()

    private lazy var fieldsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Space.base00.rawValue
        return view
    }()

    private lazy var actionButton = Button(
        style: .primary,
        label: ""
    ) {[weak self] in
    }

    // MARK: - Override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        fieldsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(containerView)

        containerView.addSubview(titleStackView)

        containerView.addSubview(arrowView)
        titleStackView.addArrangedSubview(titleText)
        titleStackView.addArrangedSubview(descriptionText)

        containerView.addSubview(lineView)

        containerView.addSubview(costStackView)
        costStackView.addArrangedSubview(costTitleText)
        costStackView.addArrangedSubview(costValueText)

        containerView.addSubview(fieldsStackView)
        containerView.addSubview(actionButton)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base00.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base00.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base04.rawValue)
            $0.leading.equalToSuperview().inset(Space.base02.rawValue)
            $0.trailing.equalTo(arrowView.snp.leading).offset(-Space.base02.rawValue)
        }
        arrowView.snp.makeConstraints {
            $0.centerY.equalTo(titleStackView.snp.centerY)
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
            $0.height.equalTo(CGFloat(Layout.Size.arrow))
            $0.width.equalTo(CGFloat(Layout.Size.arrow))
        }
        costStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(Space.base02.rawValue)
            $0.leading.equalToSuperview().inset(Space.base02.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(costStackView.snp.bottom).offset(Space.base02.rawValue)
            $0.height.equalTo(CGFloat(Layout.Size.line))
            $0.leading.equalToSuperview().inset(Space.base02.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
        fieldsStackView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(Space.base02.rawValue)
            $0.leading.equalToSuperview().inset(Space.base02.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
        actionButton.snp.makeConstraints {
            $0.top.equalTo(fieldsStackView.snp.bottom).offset(Space.base02.rawValue)
            $0.leading.equalToSuperview().inset(Space.base02.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base02.rawValue)
            $0.height.equalTo(CGFloat(Layout.Size.buttonHeight))
        }
    }

    func configureViews() {
        arrowView.isHidden = true
        actionButton.isEnabled = false
        actionButton.alpha = 0.5
        selectionStyle = .none
    }

    func setup(with model: PurchaseCustodyDTO.Card) {
        createTitleLabel(with: model)
        createCostLabels(with: model)
        createFieldViews(model.fields)
    }

    // MARK: - Private

    private func createTitleLabel(with model: PurchaseCustodyDTO.Card) {
        titleText.value = model.title.value
        titleText.setTypograph(model.title.typograph)
    }

    private func createCostLabels(with model: PurchaseCustodyDTO.Card) {
        costTitleText.value = model.fields.first?.label?.value ?? ""
        if let costTitleTypograph = model.fields.first?.label?.typograph {
            costTitleText.setTypograph(costTitleTypograph)
        }
        if let costValueTypograph = model.fields.first?.value?.typograph {
            costValueText.setTypograph(costValueTypograph)
        }
        costValueText.value = model.fields.first?.value?.value ?? ""
    }

    private func createFieldViews(_ fields: [PurchaseCustodyDTO.Field]) {
        fields.forEach { field in
            if fields.first == field { return }
            let titleLabel = Text()
            titleLabel.value = field.label?.value ?? ""
            if let titleTypograph = field.label?.typograph {
                titleLabel.setTypograph(titleTypograph)
            }
            let detailLabel = Text()
            detailLabel.value = field.value?.value ?? ""
            if let detailTypograph = field.value?.typograph {
                detailLabel.setTypograph(detailTypograph)
            }
            let stackView = createFieldStackView()
            detailLabel.textAlignment = .right
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(detailLabel)
            fieldsStackView.addArrangedSubview(stackView)
        }
    }

    private func createFieldStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Space.base00.rawValue
        view.distribution = .fill
        return view
    }
}

