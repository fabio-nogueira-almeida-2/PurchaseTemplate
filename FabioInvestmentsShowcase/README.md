# Fabio's Investment Flows Showcase

This iOS project showcases the investment flows and screens developed by **Fabio Nogueira de Almeida** from the PicPay iOS codebase. The project demonstrates the **VIP (View-Interactor-Presenter) architecture** with **backend template approach** using `StringToken` and `StringWithTypograph` for dynamic content styling.

## 🏗️ Architecture

### VIP Pattern
- **View**: UI components and user interactions
- **Interactor**: Business logic and data processing
- **Presenter**: Data transformation and view updates

### Backend Template Architecture
- **StringToken**: Backend-provided content with styling metadata
- **StringWithTypograph**: Local styling application based on backend tokens
- **Dynamic Content**: Server-driven content with client-side styling

## 📱 Featured Flows

### 1. Purchase Custody
- **Location**: `Flows/PurchaseCustody/`
- **Features**: Investment custody management with filtering (orders vs custody)
- **Key Components**:
  - `PurchaseCustodyViewController` - Main view controller
  - `PurchaseCustodyInteractor` - Business logic
  - `PurchaseCustodyPresenter` - Data transformation
  - `PurchaseCustodyService` - API communication
  - `PurchaseCustodyCoordinator` - Navigation management

### 2. Purchase Offer Detail
- **Location**: `Flows/PurchaseDetail/`
- **Features**: Detailed investment product information
- **Key Components**:
  - `PurchaseDetailViewController` - Product detail view
  - `PurchaseDetailInteractor` - Detail business logic
  - `PurchaseDetailPresenter` - Detail data transformation
  - `PurchaseDetailService` - Detail API calls

### 3. Purchase Offers List
- **Location**: `Flows/PurchaseList/`
- **Features**: List of available investment offers
- **Key Components**:
  - `PurchaseListViewController` - Offers list view
  - `PurchaseListInteractor` - List business logic
  - `PurchaseListPresenter` - List data transformation
  - `PurchaseListService` - List API calls

### 4. Orders Management
- **Location**: `Flows/Orders/`
- **Features**: Order management system
- **Key Components**:
  - `OrdersViewController` - Orders list view
  - `OrderTableViewCell` - Order display cell
  - Order status tracking and management

### 5. Purchase Result
- **Location**: `Flows/PurchaseResult/`
- **Features**: Investment purchase confirmation screens
- **Key Components**:
  - `PurchaseResultViewController` - Success confirmation view
  - `PurchaseResultInteractor` - Result business logic
  - `PurchaseResultPresenter` - Result data handling

## 🎨 Backend Template Features

### StringToken System
```swift
public struct StringToken: Decodable, Equatable {
    let value: String
    let style: String
}
```

### Typography System
```swift
public enum PurchaseTypograph: String, Equatable {
    case title1, title2, title3
    case headline, body1, body2
    case caption, overline
}
```

### Dynamic Content Application
```swift
public struct StringWithTypograph: Equatable {
    var value: String
    var typograph: PurchaseTypograph
    
    public init(stringToken: StringToken) {
        self.value = stringToken.value
        self.typograph = PurchaseTypograph(rawValue: stringToken.style) ?? .body1
    }
}
```

## 📄 JSON Mock System

### Service Stubs
The project uses **JSON files as service stubs** to simulate real backend responses, making it much more realistic than hardcoded mocks:

```
Mocks/JSON/
├── purchase_custody_position.json
├── purchase_custody_orders.json
├── purchase_custody_custody.json
├── purchase_detail.json
└── purchase_list.json
```

### JSON Service
```swift
class JSONService {
    func loadJSONWithDelay<T: Decodable>(
        filename: String, 
        type: T.Type, 
        delay: TimeInterval = 1.0, 
        completion: @escaping (Result<T, ApiError>) -> Void
    )
}
```

### Realistic Data Structure
Each JSON file contains **realistic investment data** with proper **StringToken** structure:
```json
{
  "title": {
    "value": "Tesouro Selic 2029",
    "style": "title1"
  },
  "detail": {
    "value": "Government bond with inflation protection",
    "style": "body1"
  }
}
```

## 🚀 Getting Started

1. **Open the project** in Xcode
2. **Build and run** the app
3. **Navigate through the flows** using the main menu
4. **Explore each flow** to see Fabio's implementation

## 📋 Project Structure

```
FabioInvestmentsShowcase/
├── Core/
│   ├── Models/
│   │   ├── StringToken.swift
│   │   └── InvestmentModels.swift
│   ├── Extensions/
│   │   ├── Array+Extensions.swift
│   │   └── String+Extensions.swift
│   ├── Mocks/
│   │   └── MockDependencies.swift
│   └── Localization/
│       └── Strings.swift
├── Flows/
│   ├── PurchaseCustody/
│   ├── PurchaseDetail/
│   ├── PurchaseList/
│   ├── Orders/
│   └── PurchaseResult/
└── MainMenuViewController.swift
```

## 🔧 Key Features Demonstrated

- **VIP Architecture**: Clean separation of concerns
- **Backend Template**: Server-driven content with client styling
- **Coordinator Pattern**: Navigation management
- **Service Layer**: API communication with JSON stubs
- **Factory Pattern**: Dependency injection
- **Error Handling**: Comprehensive error management
- **Loading States**: User feedback during operations
- **JSON Mock Data**: Realistic JSON files simulating backend responses
- **Service Stubs**: Production-like service layer with local JSON files

## 👨‍💻 Original Author

**Fabio Nogueira de Almeida** - Senior iOS Developer at PicPay

This showcase demonstrates his expertise in:
- Clean Architecture implementation
- Backend-driven UI systems
- Investment and financial app development
- VIP pattern mastery
- Service-oriented architecture

## 📱 Usage

1. Launch the app
2. Select a flow from the main menu
3. Interact with the screens to see the full functionality
4. Navigate between different flows
5. Observe the backend template architecture in action

Each flow is fully functional with mock data and demonstrates the complete user journey that Fabio implemented in the original PicPay investment module.
