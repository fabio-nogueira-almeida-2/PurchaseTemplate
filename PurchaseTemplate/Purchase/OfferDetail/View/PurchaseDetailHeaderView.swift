import UIKit

final class PurchaseDetailHeaderView: UIView, ViewConfiguration {
    // MARK: - View
    private lazy var titleText: Text = {
        let view = Text()
        view.font(Font.medium)
        view.foreground(color: .grayScale900)
        return view
    }()

    private lazy var detailText: Text = {
        let view = Text()
        view.font(Font.note)
        view.foreground(color: .grayScale800)
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
        addSubview(detailText)
    }

    func setupConstraints() {
        titleText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Space.base03.rawValue)
            $0.leading.equalToSuperview().inset(Space.base03.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base03.rawValue)
        }
        detailText.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(Space.base03.rawValue)
            $0.leading.equalToSuperview().inset(Space.base03.rawValue)
            $0.trailing.equalToSuperview().inset(Space.base03.rawValue)
            $0.bottom.equalToSuperview()
        }
    }

    func configureViews() {
        backgroundColor = .white
    }

    func configureStyles() {
    }

    // MARK: - Setup
    func setup(title: StringWithTypograph, detail: StringWithTypograph) {
        titleText.value = title.value
        titleText.setTypograph(title.typograph.rawValue)
        detailText.value = detail.value
        detailText.setTypograph(detail.typograph.rawValue)
    }
}
