import Apollo
import UI

final class PurchaseWelcomeCardView: UIView, ViewConfiguration {
    // MARK: - View
    lazy var avatar: Avatar = {
        let view = Avatar()
        view.style(.circle)
        view.size(.medium)
        view.background(color: .primary200.opacity(.light))
        view.foreground(color: .primary500)
        return view
    }()

    lazy var titleText: Text = {
        let view = Text()
        view.font(Font.small)
        return view
    }()

    lazy var descriptionText: Text = {
        let view = Text()
        view.font(Font.note)
        view.lineLimit(2)
        view.foreground(color: .grayScale800)
        return view
    }()

    lazy var line: UIView = {
        let view = UIView()
        view.background(color: .grayScale200)
        return view
    }()

    // MARK: - Initialize
    init(text: String, description: String, icon: Icon) {
        super.init(frame: .zero)
        buildLayout()
        titleText.value = text
        descriptionText.value = description
        avatar.image(icon, .primary500)
    }

    init(text: StringWithTypograph, description: StringWithTypograph, icon: Icon) {
        super.init(frame: .zero)
        buildLayout()
        titleText.value = text.value
        titleText.setTypograph(text.typograph)
        descriptionText.value = description.value
        descriptionText.setTypograph(description.typograph)
        avatar.image(icon, .primary500)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(avatar)
        addSubview(titleText)
        addSubview(descriptionText)
        addSubview(line)
    }

    func setupConstraints() {
        avatar.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        titleText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base02.rawValue)
            $0.leading.equalTo(avatar.snp.trailing).offset(Space.base02.rawValue)
            $0.trailing.equalToSuperview()
        }
        descriptionText.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(Space.base02.rawValue)
            $0.leading.equalTo(titleText.snp.leading)
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base03.rawValue)
        }
        line.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
