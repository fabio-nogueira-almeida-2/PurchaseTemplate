import Apollo
import SkeletonView
import UI
import UIKit
import UIKitUtilities

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
        background(color: .background00)
    }

    func buildViewHierarchy() {
        addSubviews(rootStackView)
    }

    func setupConstraints() {
        rootStackView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview().inset(Space.base04.rawValue)
        }

        addTitleComponentToListStack()
        addLineComponentToListStack()
    }

    private func getSkeletonBox(color: Color = Color.grayScale200, opacity: Apollo.Opacity = .full) -> UIView {
        let view = UIView()
        view.background(color: color)
        view.corner(radius: .large)
        view.clipsToBounds = true
        view.isSkeletonable = true
        let gradient = SkeletonGradient(baseColor: color.color.withAlphaComponent(opacity))
        view.showAnimatedGradientSkeleton(usingGradient: gradient)
        return view
    }

    private func addLineComponentToListStack() {
        for _ in 1...4 {
            let box = getSkeletonBox()
            rootStackView.addArrangedSubview(box)
            box.snp.makeConstraints {
                $0.height.equalTo(Layout.Size.listItemHeight)
                $0.trailing.leading.equalToSuperview()
            }
        }
    }

    private func addTitleComponentToListStack() {
        let firstLine = getSkeletonBox()
        firstLine.corner(radius: .medium)
        let secondLine = getSkeletonBox()
        secondLine.corner(radius: .medium)
        rootStackView.addArrangedSubview(firstLine)
        rootStackView.addArrangedSubview(secondLine)
        firstLine.snp.makeConstraints {
            $0.height.equalTo(Space.base03.rawValue)
            $0.leading.trailing.equalToSuperview()
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
            $0.height.equalTo(Space.base09.rawValue)
            $0.trailing.leading.equalToSuperview()
        }

        let filter = getSkeletonBox()
        searchBarStackView.addSubview(filter)

        let field = getSkeletonBox()
        searchBarStackView.addSubview(field)

        field.snp.makeConstraints {
            $0.height.equalTo(Space.base07.rawValue)
            $0.top.leading.equalToSuperview()
        }
        filter.snp.makeConstraints {
            $0.height.width.equalTo(Space.base07.rawValue)
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(field.snp.trailing).offset(Space.base03.rawValue)
        }
    }
}
