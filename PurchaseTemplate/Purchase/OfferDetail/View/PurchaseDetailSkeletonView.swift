import UIKit

// MARK: - Layout
private extension PurchaseDetailSkeletonView.Layout {
    enum Size {
        static let listBiggerTextInset: CGFloat = 180.0
        static let listSmallerTextInset: CGFloat = 200.0
    }
}

final class PurchaseDetailSkeletonView: UIView, ViewConfiguration, StatefulViewing {
    fileprivate enum Layout { }
    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.base08.rawValue
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var headerStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.base02.rawValue
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var bodyStackview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.base06.rawValue
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
        backgroundColor = Color.background00.uiColor
    }

    func buildViewHierarchy() {
        addSubview(rootStackView)
        rootStackView.addArrangedSubview(headerStackview)
        rootStackView.addArrangedSubview(bodyStackview)
    }

    func setupConstraints() {
        rootStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base04.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }

        headerStackview.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        bodyStackview.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        addLinesToHeaderStack()
        addListSectionToBodyStack()
        addListSectionToBodyStack()
    }

    private func getSkeletonBox(
        color: Color = Color.grayScale200,
        cornerRadius: CGFloat = 8
    ) -> UIView {
        let view = UIView()
        view.backgroundColor = color.uiColor
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        // Add simple skeleton animation
        addSkeletonAnimation(to: view)
        return view
    }

    private func addLinesToHeaderStack() {
        createTitleItem(to: headerStackview)
        createLineItem(to: headerStackview, inset: Space.base03.rawValue)
        createLineItem(to: headerStackview)
        createLineItem(to: headerStackview, inset: Space.base06.rawValue)
    }

    private func addListSectionToBodyStack() {
        createTitleItem(to: bodyStackview)
        for _ in 1...4 {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = Space.base02.rawValue
            stack.alignment = .leading
            bodyStackview.addArrangedSubview(stack)
            stack.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
            createLineItem(to: stack, inset: Layout.Size.listBiggerTextInset)
            createLineItem(to: stack, inset: Layout.Size.listSmallerTextInset)
        }
    }

    private func createTitleItem(to stack: UIStackView) {
        let title = getSkeletonBox(cornerRadius: 4)
        stack.addArrangedSubview(title)
        title.snp.makeConstraints {
            $0.height.equalTo(Space.base07.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
    }

    private func createLineItem(to stack: UIStackView, inset: CGFloat = 0) {
        let line = getSkeletonBox(cornerRadius: 4)
        stack.addArrangedSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(Space.base03.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(inset)
        }
    }
}

extension PurchaseDetailSkeletonView {
    private func addSkeletonAnimation(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.lightGray.cgColor,
            UIColor.gray.cgColor,
            UIColor.lightGray.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -view.bounds.width
        animation.toValue = view.bounds.width
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "skeletonAnimation")
    }
}
