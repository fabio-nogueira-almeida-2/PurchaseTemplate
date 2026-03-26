import Foundation
import UIKit

// MARK: - Purchase Product Model
struct PurchaseProductModel: Decodable, Equatable {
    let id: Int
    let name: StringToken
    let product: Product
    let productType: ProductType
    let information: Information
    
    struct Product: Decodable, Equatable {
        let id: Int
        let name: StringToken
    }
    
    struct ProductType: Decodable, Equatable {
        let id: Int
        let name: StringToken
        let description: StringToken?
    }
    
    struct Information: Decodable, Equatable {
        let metadatas: [Metadata]
    }
    
    struct Metadata: Decodable, Equatable {
        let label: StringToken
        let value: StringToken?
    }
}

// MARK: - API Error
enum ApiError: Error, Equatable {
    case networkError
    case serverError
    case decodingError
    case unknown
    
    var feedback: InvestmentsHubFeedback {
        switch self {
        case .networkError:
            return .connectionFailureError
        case .serverError, .decodingError, .unknown:
            return .genericError
        }
    }
}

// MARK: - Investments Hub Feedback
enum InvestmentsHubFeedback: Equatable {
    case connectionFailureError
    case genericError
    case maintenanceMode
}

// MARK: - Loading View Protocol
protocol LoadingViewProtocol: AnyObject {
    var loadingView: LoadingView { get }
    func beginState()
    func endState()
}

extension LoadingViewProtocol where Self: UIViewController {
    func beginState() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        loadingView.startAnimating()
    }
    
    func endState() {
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
    }
}

// MARK: - Loading View
class LoadingView: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}

