//
//  ErrorHandler.swift
//  PurchaseTemplate
//
//  Standardized error handling across the application
//

import UIKit

enum AppError: LocalizedError {
    case networkError(String)
    case decodingError(String)
    case validationError(String)
    case unknownError(String)
    case apiError(ApiError)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .decodingError(let message):
            return "Data Error: \(message)"
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .unknownError(let message):
            return "Error: \(message)"
        case .apiError(let apiError):
            return feedbackMessage(apiError.feedback)
        }
    }
    
    var userFriendlyMessage: String {
        switch self {
        case .networkError:
            return "Unable to connect. Please check your internet connection and try again."
        case .decodingError:
            return "Unable to process the data. Please try again later."
        case .validationError(let message):
            return message
        case .unknownError(let message):
            return message.isEmpty ? "An unexpected error occurred. Please try again." : message
        case .apiError(let apiError):
            return feedbackMessage(apiError.feedback)
        }
    }
    
    private func feedbackMessage(_ feedback: InvestmentsHubFeedback) -> String {
        switch feedback {
        case .connectionFailureError:
            return "Connection error. Please check your internet connection and try again."
        case .genericError:
            return "An error occurred. Please try again later."
        case .maintenanceError:
            return "Service under maintenance. Please try again later."
        }
    }
}

protocol ErrorHandling {
    func handleError(_ error: Error, retryAction: (() -> Void)?)
}

extension ErrorHandling where Self: UIViewController {
    func handleError(_ error: Error, retryAction: (() -> Void)? = nil) {
        let appError: AppError
        
        if let apiError = error as? ApiError {
            appError = .apiError(apiError)
        } else if let appErr = error as? AppError {
            appError = appErr
        } else {
            appError = .unknownError(error.localizedDescription)
        }
        
        let alert = UIAlertController(
            title: "Error",
            message: appError.userFriendlyMessage,
            preferredStyle: .alert
        )
        
        if let retryAction = retryAction {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                retryAction()
            })
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

