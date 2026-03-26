// import Apollo // Commented out - replaced with mock implementation
// import UI // Commented out - replaced with mock implementation
import UIKit

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
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()

    lazy var titleText: Text = {
        let view = Text()
        view.font(Font.label)
        view.foreground(color: .grayScale900)
        view.numberOfLines = 0
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

    func configureViews() {
        // Configure view appearance if needed
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(icon)
        addSubview(titleText)
    }

    func setupConstraints() {
        icon.snp.makeConstraints {
            $0.width.equalTo(Layout.Size.icon)
            $0.height.equalTo(Layout.Size.icon)
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(Space.base02.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base02.rawValue)
        }
        titleText.snp.makeConstraints {
            let offset = Space.base00.rawValue
            $0.leading.equalTo(icon.snp.trailing).offset(offset)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(Space.base02.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base02.rawValue)
        }
    }
}
