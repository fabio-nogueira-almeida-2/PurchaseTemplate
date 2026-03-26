// MARK: - TEMPORARILY COMMENTED OUT - Focus on Welcome screen only

// import Apollo // Commented out - replaced with mock implementation
import UIKit
// import UI // Commented out - replaced with mock implementation

final class PurchaseCustodyHeaderView: UIView, ViewConfiguration {
    enum Layout {
        static let size = 16
        static let line = 1
    }
    // MARK: - View
    lazy var totalInvestedText: Text = {
        let view = Text()
        view.font(Font.note)
        view.textAlignment = .left
        return view
    }()

    lazy var totalInvestedValueText: Text = {
        let view = Text()
        view.font(Font.small)
        view.textAlignment = .left
        return view
    }()

    lazy var yieldBadgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.primary500.uiColor
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return imageView
    }()

    lazy var yieldBadgeText: Text = {
        let view = Text()
        view.font(Font.label.highlighted)
        view.foreground(color: .primary500)
        view.textAlignment = .right
        return view
    }()

    lazy var yieldBadgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = Space.base00.rawValue
        stackView.background(color: .background00)
        stackView.addArrangedSubview(yieldBadgeImage)
        stackView.addArrangedSubview(yieldBadgeText)
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.corner(radius: .large)
        return stackView
    }()

    lazy var yieldValueText: Text = {
        let view = Text()
        view.font(Font.note)
        view.foreground(color: .primary500)
        view.textAlignment = .right
        return view
    }()

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
           $0.leading.equalTo(totalInvestedText.snp.trailing).offset(Space.base02.rawValue)
           $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
       }
        yieldValueText.snp.makeConstraints {
            $0.top.equalTo(yieldBadgeStackView.snp.bottom).offset(Space.base00.rawValue)
            $0.leading.equalTo(totalInvestedValueText.snp.trailing).offset(Space.base02.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.bottom.equalTo(totalInvestedValueText.snp.bottom)
        }
        yieldBadgeImage.snp.makeConstraints {
            $0.size.equalTo(Space.base03.rawValue)
        }
    }

    func configureViews() {
        background(color: .background00)
        // Set content hugging and compression resistance to prevent infinite expansion
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
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
            yieldBadgeImage.image = Icon.chartLineUptrend.image?.withRenderingMode(.alwaysTemplate)
        } else if info.typograph == .noteNegative {
            yieldBadgeImage.image = Icon.chartLineUptrend.image?.withRenderingMode(.alwaysTemplate)
        } else {
            yieldBadgeImage.image = Icon.chartLineUptrend.image?.withRenderingMode(.alwaysTemplate)
        }
    }
}

