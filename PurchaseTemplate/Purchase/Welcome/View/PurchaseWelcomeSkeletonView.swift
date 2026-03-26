// import Apollo // Commented out - replaced with mock implementation
// import SkeletonView // Commented out - replaced with mock implementation
// import UI // Commented out - replaced with mock implementation
import UIKit
// import UIKitUtilities // Commented out - replaced with mock implementation

// MARK: - Layout
private extension PurchaseWelcomeSkeletonView.Layout {
    enum Size {
        static let listItemHeight: CGFloat = 80.0
    }
}

final class PurchaseWelcomeSkeletonView: UIView, ViewConfiguration, StatefulViewing {
    fileprivate enum Layout { }
    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.base08.rawValue
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.base03.rawValue
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var bodyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.base08.rawValue
        stackView.alignment = .leading
        return stackView
    }()

    var viewModel: StatefulViewModeling?
    weak var delegate: StatefulDelegate?

    // MARK: - Initialization
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildLayout()
    }

    // MARK: - ViewConfiguration
    func configureViews() {
        background(color: .background00)
    }

    func buildViewHierarchy() {
        addSubview(rootStackView)
        rootStackView.addArrangedSubview(headerStackView)
        rootStackView.addArrangedSubview(bodyStackView)
    }

    func setupConstraints() {
        rootStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
        }

        headerStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        bodyStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        setupHeader()
        addLineToBody()
        addButtonItem(to: rootStackView)
    }

    private func getSkeletonBox(cornerRadius: Radius = .large) -> UIView {
        let view = UIView()
        view.background(color: .grayScale200)
        view.corner(radius: cornerRadius)
        view.clipsToBounds = true
        // Simple skeleton animation without SkeletonView library
        addSkeletonAnimation(to: view)
        return view
    }
    
    private func addSkeletonAnimation(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            Color.grayScale200.uiColor.cgColor,
            Color.grayScale200.uiColor.withAlphaComponent(0.5).cgColor,
            Color.grayScale200.uiColor.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -view.bounds.width
        animation.toValue = view.bounds.width
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "skeleton")
    }

    private func setupHeader() {
        let imageBox = getSkeletonBox()
        headerStackView.addArrangedSubview(imageBox)
        imageBox.snp.makeConstraints {
            $0.size.equalTo(Space.base10.rawValue)
            $0.leading.equalToSuperview()
        }
        addTitleToHeader()
    }

    private func addLineToBody() {
        for _ in 1...4 {
            let view = UIView()
            bodyStackView.addArrangedSubview(view)
            view.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.leading.equalToSuperview()
                $0.height.equalTo(Layout.Size.listItemHeight)
            }

            let icon = getSkeletonBox(cornerRadius: .strong)
            view.addSubview(icon)
            icon.snp.makeConstraints {
                $0.size.equalTo(Space.base06.rawValue)
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview()
            }

            let textStack = UIStackView()
            textStack.axis = .vertical
            textStack.spacing = Space.base02.rawValue
            view.addSubview(textStack)
            addTitleItem(to: textStack)
            addLineItem(to: textStack)
            addLineItem(to: textStack, inset: Space.base12.rawValue)
            textStack.snp.makeConstraints {
                let offset = Space.base03.rawValue
                $0.leading.equalTo(icon.snp.trailing).offset(offset)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
        }
    }

    private func addTitleToHeader() {
        addTitleItem(to: headerStackView)
        addLineItem(to: headerStackView)
        addLineItem(to: headerStackView, inset: Space.base10.rawValue)
    }

    private func addTitleItem(to stack: UIStackView) {
        let title = getSkeletonBox(cornerRadius: .medium)
        stack.addArrangedSubview(title)
        title.snp.makeConstraints {
            $0.height.equalTo(Space.base07.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
    }

    private func addLineItem(to stack: UIStackView, inset: CGFloat = 0) {
        let line = getSkeletonBox(cornerRadius: .medium)
        stack.addArrangedSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(Space.base03.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(inset)
        }
    }

    private func addButtonItem(to stack: UIStackView) {
        let button = getSkeletonBox(cornerRadius: .medium)
        stack.addArrangedSubview(button)
        button.snp.makeConstraints {
            $0.height.equalTo(Space.base08.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
