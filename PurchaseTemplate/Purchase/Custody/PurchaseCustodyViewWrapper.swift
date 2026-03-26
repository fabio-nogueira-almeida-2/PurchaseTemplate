//
//  PurchaseCustodyViewWrapper.swift
//  PurchaseTemplate
//
//  SwiftUI wrapper for PurchaseCustodyViewController
//  NOTE: Currently commented out - Custody flow not fully implemented
//

import SwiftUI
import UIKit

// TODO: Uncomment when PurchaseCustodyView is fully implemented
/*
struct PurchaseCustodyViewWrapper: UIViewControllerRepresentable {
    let productId: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = PurchaseCustodyFactory.make(productId: productId)
        let navController = UINavigationController(rootViewController: viewController)
        
        // Set navigation controller reference for deeplink handling
        DispatchQueue.main.async {
            if let mockNavManager = DependencyContainer().navigationManager as? MockNavigationManager {
                mockNavManager.setNavigationController(navController)
            }
            if let mockDeeplinkOpener = DependencyContainer().deeplinkOpener as? MockDeeplinkOpener {
                mockDeeplinkOpener.setNavigationController(navController)
            }
        }
        
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update if needed
        if let navController = uiViewController as? UINavigationController {
            DispatchQueue.main.async {
                if let mockNavManager = DependencyContainer().navigationManager as? MockNavigationManager {
                    mockNavManager.setNavigationController(navController)
                }
                if let mockDeeplinkOpener = DependencyContainer().deeplinkOpener as? MockDeeplinkOpener {
                    mockDeeplinkOpener.setNavigationController(navController)
                }
            }
        }
    }
}

#Preview {
    PurchaseCustodyViewWrapper(productId: "1")
}
*/

