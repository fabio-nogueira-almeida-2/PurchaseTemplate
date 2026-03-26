import SwiftUI

struct ContentView: View {
    @State private var selectedFlow: InvestmentFlow?
    @State private var showingFlowDetails = false
    @State private var navigationController: UINavigationController?
    
    private let menuItems = [
        MenuItem(title: "Purchase Custody", description: "Investment custody management with filtering", flow: .custody, icon: "briefcase.fill", color: .blue),
        MenuItem(title: "Purchase Offer Detail", description: "Detailed investment product information", flow: .offerDetail, icon: "doc.text.fill", color: .green),
        MenuItem(title: "Purchase Offers List", description: "List of available investment offers", flow: .offersList, icon: "list.bullet", color: .orange),
        MenuItem(title: "Orders Management", description: "Order management system", flow: .orders, icon: "cart.fill", color: .purple),
        MenuItem(title: "Purchase Result", description: "Investment purchase confirmation", flow: .result, icon: "checkmark.circle.fill", color: .red)
    ]
    
    var body: some View {
        NavigationLink {
            let service = PurchaseCustodyService()
            let presenter = PurchaseCustodyPresenter()
            let interactor = PurchaseCustodyInteractor(
                service: service,
                presenter: presenter,
                dependencies: MockDependencies(),
                productId: "123"
            )
            PurchaseCustodyViewController(interactor: interactor). as AnyView
        } label: {
            List(menuItems) { item in
                Text(item.title)
            }
        }
        .onAppear {
            // Get the navigation controller from the hosting view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootVC = window.rootViewController as? UINavigationController {
                navigationController = rootVC
            }
        }
    }
    
    private func launchRealFlow(_ flow: InvestmentFlow) {
        // Show flow details with realistic data from Fabio's original work
        selectedFlow = flow
        showingFlowDetails = true
    }
}

struct FlowRowView: View {
    let item: MenuItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(item.color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ScreenRow: View {
    let screen: ScreenInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: screen.icon)
                    .font(.title2)
                    .foregroundColor(screen.color)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(screen.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(screen.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct MockDataRow: View {
    let item: MockDataItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let value = item.value {
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            if let subtitle = item.subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct ScreenInfo: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let color: Color
}

struct MockDataItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String?
    let subtitle: String?
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let flow: InvestmentFlow
    let icon: String
    let color: Color
}

enum InvestmentFlow: CaseIterable {
    case custody
    case offerDetail
    case offersList
    case orders
    case result
    
    func navigateToFlow(_ flow: InvestmentFlow, navigationController: UINavigationController) {
//        switch flow {
//        case .custody:
            let coordinator = PurchaseCustodyCoordinator(navigationController: navigationController)
            coordinator.start()
//        case .offerDetail:
//            let coordinator = PurchaseDetailCoordinator(navigationController: navigationController)
//            coordinator.start()
//        case .offersList:
//            let coordinator = PurchaseListCoordinator(navigationController: navigationController)
//            coordinator.start()
//        case .orders:
//            let coordinator = OrdersCoordinator(navigationController: navigationController)
//            coordinator.start()
//        case .result:
//            let coordinator = PurchaseResultCoordinator(navigationController: navigationController)
//            coordinator.start()
//        }
    }

    var title: String {
        switch self {
        case .custody: return "Purchase Custody"
        case .offerDetail: return "Purchase Offer Detail"
        case .offersList: return "Purchase Offers List"
        case .orders: return "Orders Management"
        case .result: return "Purchase Result"
        }
    }
    
    var description: String {
        switch self {
        case .custody: return "Investment custody management with filtering capabilities"
        case .offerDetail: return "Detailed investment product information display"
        case .offersList: return "List of available investment offers with filtering"
        case .orders: return "Order management system with status tracking"
        case .result: return "Investment purchase confirmation and results"
        }
    }
    
    var screens: [ScreenInfo] {
        switch self {
        case .custody:
            return [
                ScreenInfo(name: "Custody List", description: "Main custody management screen with filtering options", icon: "list.bullet", color: .blue),
                ScreenInfo(name: "Custody Detail", description: "Detailed view of specific custody item", icon: "doc.text", color: .green),
                ScreenInfo(name: "Filter Options", description: "Advanced filtering and search capabilities", icon: "slider.horizontal.3", color: .orange)
            ]
        case .offerDetail:
            return [
                ScreenInfo(name: "Product Overview", description: "Main product information and details", icon: "info.circle", color: .blue),
                ScreenInfo(name: "Investment Form", description: "Investment amount and terms selection", icon: "pencil", color: .green),
                ScreenInfo(name: "Risk Assessment", description: "Risk level and investment suitability", icon: "exclamationmark.triangle", color: .orange)
            ]
        case .offersList:
            return [
                ScreenInfo(name: "Offers List", description: "List of available investment offers", icon: "list.bullet", color: .blue),
                ScreenInfo(name: "Search & Filter", description: "Search and filter investment options", icon: "magnifyingglass", color: .green),
                ScreenInfo(name: "Offer Cards", description: "Individual offer cards with key information", icon: "rectangle.stack", color: .purple)
            ]
        case .orders:
            return [
                ScreenInfo(name: "Orders List", description: "List of all investment orders", icon: "list.bullet", color: .blue),
                ScreenInfo(name: "Order Detail", description: "Detailed view of specific order", icon: "doc.text", color: .green),
                ScreenInfo(name: "Status Tracking", description: "Order status and progress tracking", icon: "clock", color: .orange)
            ]
        case .result:
            return [
                ScreenInfo(name: "Success Screen", description: "Investment purchase confirmation", icon: "checkmark.circle", color: .green),
                ScreenInfo(name: "Transaction Summary", description: "Complete transaction details and receipt", icon: "doc.text", color: .blue),
                ScreenInfo(name: "Next Steps", description: "Guidance for next investment actions", icon: "arrow.right", color: .purple)
            ]
        }
    }
    
    var mockData: [MockDataItem] {
        switch self {
        case .custody:
            return [
                MockDataItem(title: "Product", value: "Tesouro Selic 2029", subtitle: "Government Bond"),
                MockDataItem(title: "Amount", value: "R$ 1.000,00", subtitle: "Minimum investment"),
                MockDataItem(title: "Status", value: "Active", subtitle: "Currently available"),
                MockDataItem(title: "Yield", value: "6.5% annually", subtitle: "Expected return")
            ]
        case .offerDetail:
            return [
                MockDataItem(title: "Product Name", value: "CDB Banco XYZ", subtitle: "Bank Certificate of Deposit"),
                MockDataItem(title: "Investment Amount", value: "R$ 2.500,00", subtitle: "Minimum required"),
                MockDataItem(title: "Maturity", value: "2 years", subtitle: "Investment period"),
                MockDataItem(title: "Expected Yield", value: "8.2% annually", subtitle: "Projected return"),
                MockDataItem(title: "Risk Level", value: "Low", subtitle: "Conservative investment")
            ]
        case .offersList:
            return [
                MockDataItem(title: "Tesouro Selic 2029", value: "R$ 1.000,00", subtitle: "Government Bond - 6.5% yield"),
                MockDataItem(title: "CDB Banco XYZ", value: "R$ 2.500,00", subtitle: "Bank CD - 8.2% yield"),
                MockDataItem(title: "Fund of Funds", value: "R$ 500,00", subtitle: "Investment Fund - 7.8% yield"),
                MockDataItem(title: "Music Royalties", value: "R$ 5.000,00", subtitle: "Alternative Investment - 8-12% yield")
            ]
        case .orders:
            return [
                MockDataItem(title: "Order #001", value: "Completed", subtitle: "Tesouro Selic 2029 - R$ 1.000,00"),
                MockDataItem(title: "Order #002", value: "Pending", subtitle: "CDB Banco XYZ - R$ 2.000,00"),
                MockDataItem(title: "Order #003", value: "Processing", subtitle: "Fund of Funds - R$ 500,00"),
                MockDataItem(title: "Order #004", value: "Completed", subtitle: "Music Royalties - R$ 5.000,00")
            ]
        case .result:
            return [
                MockDataItem(title: "Transaction ID", value: "TXN-123456789", subtitle: "Unique identifier"),
                MockDataItem(title: "Investment Amount", value: "R$ 2.500,00", subtitle: "Total invested"),
                MockDataItem(title: "Product", value: "CDB Banco XYZ", subtitle: "Bank Certificate of Deposit"),
                MockDataItem(title: "Status", value: "Success", subtitle: "Transaction completed"),
                MockDataItem(title: "Confirmation", value: "Email sent", subtitle: "Receipt delivered")
            ]
        }
    }
}

// UIKit Integration
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: ContentView())
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
