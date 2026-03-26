import Apollo
import Core
import UI
import Core

final class PurchaseWelcomeHeaderImageView: UIView, ViewConfiguration {
    enum Layout {
        enum Size {
            static let image: CGFloat = 64
        }
    }

    // MARK: - View
    lazy var containerView: UIView = {
        let view = UIView()
        view.background(color: .black)
        view.corner(radius: .large)
        return view
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView(image: Icon.invoice.image)
        view.tintColor = UIColor(hex: "#FFD55B")
        return view
    }()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setup(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.setImage(url: url)
        }
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(imageView)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.height.width.equalTo(Layout.Size.image)
            $0.top.bottom.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
