import Apollo
import UI

final class PurchaseCustodyHeaderView: UIView, ViewConfiguration {
    enum Layout {
        static let size = 16
        static let line = 1
    }
    // MARK: - View
    lazy var totalInvestedText = Text()
        .font(Font.note)
        .multilineTextAlignment(.left)

    lazy var totalInvestedValueText = Text()
        .font(Font.small)
        .multilineTextAlignment(.left)

    lazy var yieldBadgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.primary500.color
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return imageView
    }()

    lazy var yieldBadgeText = Text()
        .font(Font.label.highlighted)
        .foreground(color: .primary500)
        .multilineTextAlignment(.right)

    lazy var yieldBadgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = Space.base00.rawValue
        stackView.background(color: .grayScale050)
        stackView.addArrangedSubview(yieldBadgeImage)
        stackView.addArrangedSubview(yieldBadgeText)
        stackView.background(color: .light)
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.corner(radius: .large)
        return stackView
    }()

    lazy var yieldValueText = Text()
        .font(Font.note, maximumPointSize: 10)
        .foreground(color: .primary500)
        .multilineTextAlignment(.right)

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(totalInvestedText)
        addSubview(totalInvestedValueText)
        addSubview(yieldBadgeStackView)
        addSubview(yieldValueText)
    }

    func setupConstraints() {
        totalInvestedText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base02.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
        }
        totalInvestedValueText.snp.makeConstraints {
            $0.top.equalTo(totalInvestedText.snp.bottom).offset(Space.base00.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base02.rawValue)
        }
       yieldBadgeStackView.snp.makeConstraints {
           $0.centerY.equalTo(totalInvestedText.snp.centerY)
           $0.leading.greaterThanOrEqualTo(totalInvestedText.snp.trailing)
           $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
       }
        yieldValueText.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(yieldBadgeStackView.snp.bottom)
            $0.leading.greaterThanOrEqualTo(totalInvestedValueText.snp.trailing)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalTo(totalInvestedValueText.snp.bottom)
        }
        yieldBadgeImage.snp.makeConstraints {
            $0.size.equalTo(Space.base03.rawValue)
        }
    }

    func configureViews() {
        background(color: .grayScale050)
    }

    func configureStyles() {
    }

    func setup(model: PurchaseCustodyDTO.Header) {
        totalInvestedText.value = model.left?.label?.value ?? ""
        if let leftLabelTopograph = model.left?.label?.typograph {
            totalInvestedText.setTypograph(leftLabelTopograph)
        }
        totalInvestedValueText.value = model.left?.value?.value ?? ""
        if let leftValueTopograph = model.left?.value?.typograph {
            totalInvestedValueText.setTypograph(leftValueTopograph)
        }
        yieldValueText.value = model.right?.value?.value ?? ""
        if let rightValueTopograph = model.right?.value?.typograph {
            yieldValueText.setTypograph(rightValueTopograph)
        }
        if let badge = model.right?.label {
            setupBadge(info: badge)
        }
        yieldBadgeText.value = model.right?.label?.value ?? ""
    }

    func setupBadge(info: StringWithTypograph) {
        yieldBadgeText.value = info.value
        if info.typograph == .notePositive {
            yieldBadgeImage.image = Icon.chartUp.image.withRenderingMode(.alwaysTemplate)
        } else if info.typograph == .noteNegative {
            Icon.chartDown.image.withRenderingMode(.alwaysTemplate)
        } else {
            Icon.chartLine.image.withRenderingMode(.alwaysTemplate)
        }
    }
}
