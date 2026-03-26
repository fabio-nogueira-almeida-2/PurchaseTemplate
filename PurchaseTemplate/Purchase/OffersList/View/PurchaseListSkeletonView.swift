import UIKit

// MARK: - Layout
private extension PurchaseListSkeletonView.Layout {
    enum Size {
        static let titleWidthComponent: CGFloat = 180.0
        static let listItemHeight: CGFloat = 120.0
    }
}

final class PurchaseListSkeletonView: UIView, ViewConfiguration, StatefulViewing {
    fileprivate enum Layout { }
    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Space.base03.rawValue
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
    }

    func setupConstraints() {
        rootStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base04.rawValue)
            $0.leading.equalToSuperview().inset(Space.base04.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base04.rawValue)
        }

        addTitleComponentToListStack()
        addLineComponentToListStack()
    }

    private func getSkeletonBox(color: Color = Color.grayScale200) -> UIView {
        let view = UIView()
        view.backgroundColor = color.uiColor
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        // Add simple skeleton animation
        addSkeletonAnimation(to: view)
        return view
    }

    private func addLineComponentToListStack() {
        for _ in 1...4 {
            let box = getSkeletonBox()
            rootStackView.addArrangedSubview(box)
            box.snp.makeConstraints {
                $0.height.equalTo(Layout.Size.listItemHeight)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
        }
    }

    private func addTitleComponentToListStack() {
        let firstLine = getSkeletonBox()
        firstLine.layer.cornerRadius = 4
        let secondLine = getSkeletonBox()
        secondLine.layer.cornerRadius = 4
        rootStackView.addArrangedSubview(firstLine)
        rootStackView.addArrangedSubview(secondLine)
        firstLine.snp.makeConstraints {
            $0.height.equalTo(Space.base03.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        secondLine.snp.makeConstraints {
            $0.height.equalTo(Space.base03.rawValue)
            $0.width.equalTo(Layout.Size.titleWidthComponent)
            $0.leading.equalToSuperview()
        }
    }

    private func addSearchComponentToListStack() {
        let searchBarStackView = UIView()
        rootStackView.addArrangedSubview(searchBarStackView)
        searchBarStackView.snp.makeConstraints {
            $0.height.equalTo(Space.base08.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        let filter = getSkeletonBox()
        searchBarStackView.addSubview(filter)

        let field = getSkeletonBox()
        searchBarStackView.addSubview(field)

        field.snp.makeConstraints {
            $0.height.equalTo(Space.base07.rawValue)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        filter.snp.makeConstraints {
            $0.height.equalTo(Space.base07.rawValue)
            $0.width.equalTo(Space.base07.rawValue)
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(field.snp.trailing).offset(Space.base03.rawValue)
        }
    }
}

extension PurchaseListSkeletonView {
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
