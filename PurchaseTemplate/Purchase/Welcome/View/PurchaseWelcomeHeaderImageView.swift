// import Apollo // Commented out - replaced with mock implementation
// import Core // Commented out - replaced with mock implementation
// import UI // Commented out - replaced with mock implementation
import UIKit

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
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
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

    func configureViews() {
        // Configure view appearance if needed
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(containerView)
        containerView.addSubview(imageView)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.height.equalTo(Layout.Size.image)
            $0.width.equalTo(Layout.Size.image)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(Layout.Size.image)
            $0.height.equalTo(Layout.Size.image)
        }
    }
}
