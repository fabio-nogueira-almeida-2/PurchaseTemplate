import Apollo
import SkeletonView
import UI
import UIKit
import UIKitUtilities

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
        background(color: .background00)
    }

    func buildViewHierarchy() {
        addSubviews(rootStackView)
        rootStackView.addArrangedSubview(headerStackview)
        rootStackView.addArrangedSubview(bodyStackview)
    }

    func setupConstraints() {
        rootStackView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview().inset(Space.base04.rawValue)
        }

        headerStackview.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
        }

        bodyStackview.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview()
        }

        addLinesToHeaderStack()
        addListSectionToBodyStack()
        addListSectionToBodyStack()
    }

    private func getSkeletonBox(
        color: Color = Color.grayScale200,
        opacity: Apollo.Opacity = .full,
        cornerRadius: Radius = .large
    ) -> UIView {
        let view = UIView()
        view.background(color: color)
        view.corner(radius: cornerRadius)
        view.clipsToBounds = true
        view.isSkeletonable = true
        let gradient = SkeletonGradient(baseColor: color.color.withAlphaComponent(opacity))
        view.showAnimatedGradientSkeleton(usingGradient: gradient)
        return view
    }

    private func addLinesToHeaderStack() {
        createTitleItem(to: headerStackview)
        createLineItem(to: headerStackview, inset: Space.base03.rawValue)
        createLineItem(to: headerStackview)
        createLineItem(to: headerStackview, inset: Space.base05.rawValue)
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
                $0.trailing.leading.equalToSuperview()
            }
            createLineItem(to: stack, inset: Layout.Size.listBiggerTextInset)
            createLineItem(to: stack, inset: Layout.Size.listSmallerTextInset)
        }
    }

    private func createTitleItem(to stack: UIStackView) {
        let title = getSkeletonBox(cornerRadius: .medium)
        stack.addArrangedSubview(title)
        title.snp.makeConstraints {
            $0.height.equalTo(Space.base07.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Space.base02.rawValue)
        }
    }

    private func createLineItem(to stack: UIStackView, inset: CGFloat = 0) {
        let line = getSkeletonBox(cornerRadius: .medium)
        stack.addArrangedSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(Space.base03.rawValue)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(inset)
        }
    }
}
