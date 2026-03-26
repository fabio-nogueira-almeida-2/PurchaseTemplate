//
//  PurchaseListViewWrapper.swift
//  PurchaseTemplate
//
//  SwiftUI wrapper for UIKit OffersList screen
//

import SwiftUI
import UIKit

struct PurchaseListViewWrapper: UIViewControllerRepresentable {
    let productId: String
    let productTypeId: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let listVC = PurchaseListFactory.make(productId: productId, productTypeId: productTypeId)
        
        // Set up navigation controller reference for deeplink handling
        if let navController = listVC.navigationController {
            let container = DependencyContainer()
            if let mockNavManager = container.navigationManager as? MockNavigationManager {
                mockNavManager.setNavigationController(navController)
            }
            if let mockDeeplinkOpener = container.deeplinkOpener as? MockDeeplinkOpener {
                mockDeeplinkOpener.setNavigationController(navController)
            }
        }
        
        return listVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Set up navigation controller reference when view appears
        if let navController = uiViewController.navigationController {
            let container = DependencyContainer()
            if let mockNavManager = container.navigationManager as? MockNavigationManager {
                mockNavManager.setNavigationController(navController)
            }
            if let mockDeeplinkOpener = container.deeplinkOpener as? MockDeeplinkOpener {
                mockDeeplinkOpener.setNavigationController(navController)
            }
        }
    }
}

// MARK: - SwiftUI Preview

#Preview {
    NavigationView {
        PurchaseListViewWrapper(productId: "1", productTypeId: "1")
    }
}


