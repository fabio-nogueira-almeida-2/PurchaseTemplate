import UIKit

final class PurchaseDetailHeaderSectionView: UIView, ViewConfiguration {
    // MARK: - View
    private lazy var titleText: Text = {
        let view = Text()
        view.font(Font.small)
        view.bold()
        view.foreground(color: .black)
        return view
    }()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - ViewConfiguration
    func buildViewHierarchy() {
        addSubview(titleText)

    }

    func setupConstraints() {
        titleText.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Space.base03.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base03.rawValue)
            $0.top.equalToSuperview().inset(Space.base03.rawValue)
            $0.bottom.equalToSuperview().inset(Space.base03.rawValue)
        }
    }

    func configureViews() {
        backgroundColor = .white
    }

    func configureStyles() {
    }

    // MARK: - Setup
    func setup(title: String) {
        titleText.value = title
    }
}
