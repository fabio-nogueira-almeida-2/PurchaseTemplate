import SwiftUI
import UIKit

struct PurchaseCatalogViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let catalogVC = PurchaseCatalogFactory.make()
        let navController = UINavigationController(rootViewController: catalogVC)
        
        // Set navigation controller for deeplink handling
        if let mockDeeplinkOpener = DependencyContainer().deeplinkOpener as? MockDeeplinkOpener {
            mockDeeplinkOpener.setNavigationController(navController)
        }
        
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update if needed
        if let navController = uiViewController as? UINavigationController,
           let mockDeeplinkOpener = DependencyContainer().deeplinkOpener as? MockDeeplinkOpener {
            mockDeeplinkOpener.setNavigationController(navController)
        }
    }
}

#Preview {
    PurchaseCatalogViewWrapper()
}

