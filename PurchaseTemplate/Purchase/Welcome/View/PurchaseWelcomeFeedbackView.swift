import Apollo
import UI

final class PurchaseWelcomeFeedbackView: UIView, ViewConfiguration {
    enum Layout {
        enum Size {
            static let icon: CGFloat = 13
        }
    }
    // MARK: - View
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.image = Icon.feedbackDangerMono.image
        return view
    }()

    lazy var titleText: Text = {
        let view = Text()
        view.font(Font.label)
        view.foreground(color: .grayScale900)
        return view
    }()

    // MARK: - Properties
    let strings = Strings.Royalty.self

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
        addSubview(icon)
        addSubview(titleText)
    }

    func setupConstraints() {
        icon.snp.makeConstraints {
            $0.width.height.equalTo(Layout.Size.icon)
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(Space.base02.rawValue)
        }
        titleText.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(Space.base00.rawValue)
            $0.centerY.equalTo(icon.snp.centerY)
        }
    }
}
