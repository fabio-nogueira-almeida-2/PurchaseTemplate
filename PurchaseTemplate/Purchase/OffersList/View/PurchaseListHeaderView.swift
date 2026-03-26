import UIKit

final class PurchaseListHeaderView: UIStackView, ViewConfiguration {
    // MARK: - View
    lazy var titleText: Text = {
        let view = Text()
        view.numberOfLines = 0
        return view
    }()

    lazy var descriptionText: Text = {
        let view = Text()
        view.numberOfLines = 0
        return view
    }()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addArrangedSubview(descriptionText)
        addArrangedSubview(titleText)
    }

    func setupConstraints() {
        // Constraints are handled by UIStackView's arranged subviews
        // No additional constraints needed
    }

    func configureViews() {
        axis = .vertical
        spacing = Space.base04.rawValue
        distribution = .fillProportionally
        layoutMargins = EdgeInsets.rootView
        isLayoutMarginsRelativeArrangement = true
        backgroundColor = .white
    }

    func setup(title: StringWithTypograph, description: StringWithTypograph) {
        titleText.value = title.value
        titleText.setTypograph(title.typograph)
        descriptionText.value = description.value
        descriptionText.setTypograph(description.typograph)
    }
}
