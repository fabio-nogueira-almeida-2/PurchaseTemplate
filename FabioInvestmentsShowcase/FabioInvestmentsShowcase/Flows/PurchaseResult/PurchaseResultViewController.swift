import UIKit

protocol PurchaseResultDisplaying: AnyObject {
}

final class PurchaseResultViewController: UIViewController {
    enum Layout {}
    
    // MARK: - View
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var titleText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Pronto! Agora é só aguardar"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var detailText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.text = "Seu investimento ficará ativo assim que a captação for concluída. Confira a evolução da sua aplicação em Meus investimentos."
        label.numberOfLines = 0
        return label
    }()

    lazy var primaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Voltar ao catálogo", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var secondaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Conferir extrato de investimento", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties
    private let interactor: PurchaseResultInteracting

    init(interactor: PurchaseResultInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        view.backgroundColor = .systemBackground
    }

    // MARK: - ViewConfiguration
    private func buildLayout() {
        view.addSubview(icon)
        view.addSubview(titleText)
        view.addSubview(detailText)
        view.addSubview(primaryButton)
        view.addSubview(secondaryButton)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        titleText.translatesAutoresizingMaskIntoConstraints = false
        detailText.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            icon.widthAnchor.constraint(equalToConstant: 60),
            icon.heightAnchor.constraint(equalToConstant: 60),
            
            titleText.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 24),
            titleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            detailText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 16),
            detailText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            detailText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            detailText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            primaryButton.topAnchor.constraint(greaterThanOrEqualTo: detailText.bottomAnchor, constant: 40),
            primaryButton.heightAnchor.constraint(equalToConstant: 48),
            primaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            primaryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: 16),
            secondaryButton.heightAnchor.constraint(equalToConstant: 48),
            secondaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            secondaryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            secondaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
    
    @objc private func primaryButtonTapped() {
        interactor.primaryButtonAction()
    }
    
    @objc private func secondaryButtonTapped() {
        interactor.secondaryButtonAction()
    }
}

extension PurchaseResultViewController: PurchaseResultDisplaying {
}
