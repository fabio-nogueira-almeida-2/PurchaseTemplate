//
//  PurchaseWelcomeViewWrapper.swift
//  PurchaseTemplate
//
//  SwiftUI wrapper for UIKit Welcome screen
//

import SwiftUI
import UIKit

struct PurchaseWelcomeViewWrapper: UIViewControllerRepresentable {
    let productId: String
    let productTypeId: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let welcomeVC = PurchaseWelcomeFactory.make(productId: productId, productTypeId: productTypeId)
        return welcomeVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Set up navigation controller reference when view appears
        // This is called after the view controller is added to the navigation hierarchy
        DispatchQueue.main.async {
            if let navController = uiViewController.navigationController {
                let container = DependencyContainer()
                if let mockNavManager = container.navigationManager as? MockNavigationManager {
                    mockNavManager.setNavigationController(navController)
                }
                if let mockDeeplinkOpener = container.deeplinkOpener as? MockDeeplinkOpener {
                    mockDeeplinkOpener.setNavigationController(navController)
                    print("✅ PurchaseWelcomeViewWrapper: Set navigation controller in MockDeeplinkOpener")
                }
            } else {
                print("⚠️ PurchaseWelcomeViewWrapper: No navigation controller found")
            }
        }
    }
}

