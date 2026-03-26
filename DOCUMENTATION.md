# Purchase Template - Complete Project Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Project Overview](#project-overview)
3. [Architecture](#architecture)
4. [Template Approach](#template-approach)
5. [Frontend Architecture](#frontend-architecture)
6. [Backend Architecture](#backend-architecture)
7. [Design System](#design-system)
8. [Flow Diagrams](#flow-diagrams)
9. [Key Concepts](#key-concepts)
10. [Implementation Details](#implementation-details)
11. [Getting Started](#getting-started)

---

## Introduction

### What is Purchase Template?

Purchase Template is a **reusable iOS application template** designed to handle purchase flows for different types of investment products. Think of it as a "blueprint" that can be customized for various investment types (like Investment Funds, Royalties, Stocks, etc.) without rewriting the entire application.

### Why Template Approach?

Instead of creating separate apps for each investment type, we use a **template-based approach** where:
- ✅ Same screens work for different product types
- ✅ Same codebase handles multiple investment flows
- ✅ Easy to add new product types
- ✅ Consistent user experience across products
- ✅ Faster development time

---

## Project Overview

### What This Project Does

This app allows users to:
1. **Browse** different types of investments
2. **View details** of specific investment offers
3. **Enter investment amount** they want to invest
4. **Confirm** their purchase
5. **See results** of their transaction

### Investment Types Supported

Currently supports:
- **Investment Funds** (`productTypeId: "1"`)
- **Royalties Investment** (`productTypeId: "2"`)
- **Investment Catalog** - Shows all investments regardless of type

But the template can easily support more types!

---

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    User Interface                       │
│  (SwiftUI Dashboard + UIKit Screens)                   │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│              VIPER Architecture Layer                   │
│  (View → Interactor → Presenter → Coordinator)         │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│              Service Layer                              │
│  (API Calls, Data Fetching)                            │
└─────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│              Mock/Backend Layer                         │
│  (Mock Services for Development)                       │
└─────────────────────────────────────────────────────────┘
```

### What is VIPER?

VIPER stands for:
- **V**iew: What the user sees (UI)
- **I**nteractor: Business logic (what to do)
- **P**resenter: Formats data for display
- **E**ntity: Data models
- **R**outer/Coordinator: Navigation between screens

Think of it like a restaurant:
- **View** = The plate (what customer sees)
- **Interactor** = The chef (does the work)
- **Presenter** = The waiter (brings food to table)
- **Entity** = The ingredients (data)
- **Router** = The host (shows you to your table)

---

## Template Approach

### Official Pattern Names

This backend approach follows several well-established software design patterns:

1. **Template Method Pattern** (GoF Design Pattern)
   - Defines the skeleton of an algorithm in a base class
   - Allows customization of specific steps without changing the overall structure
   - Promotes code reuse and flexibility

2. **Configuration-Driven Development** / **Data-Driven Architecture**
   - UI rendering is driven by configuration/data from the backend
   - Backend sends structured data (like `StringToken` with typography styles)
   - Frontend interprets and renders based on this data

3. **Multi-Tenant Template System**
   - Same endpoints serve multiple product types
   - Content adapts based on `productTypeId` parameter
   - Single codebase handles multiple tenants/products

**Combined Approach:** This implementation combines these patterns to create a **Template-Based Multi-Product Architecture** where the same screens and endpoints work for different product types through parameter-driven configuration.

### The Core Idea

Instead of hardcoding everything for one product type, we use **parameters** to make screens reusable:

```
Traditional Approach:
┌─────────────────┐
│ Funds Screen    │  ← Only works for Funds
└─────────────────┘

Template Approach:
┌─────────────────┐
│ Generic Screen  │  ← Works for ANY product type
│ + productTypeId │     when you pass productTypeId
└─────────────────┘
```

### How It Works

1. **Dashboard** → User selects investment type
2. **productTypeId** is passed through the entire flow
3. **Screens adapt** their content based on productTypeId
4. **Same code** handles different product types

### Example: Different Content for Same Screen

```swift
// When productTypeId = "1" (Investment Funds)
Welcome Screen shows:
- "Bem-vindo aos Fundos de Investimento"
- "Descubra oportunidades de investimento..."

// When productTypeId = "2" (Royalties)
Welcome Screen shows:
- "Bem-vindo aos Royalties"
- "Invista em royalties e receba rendimentos mensais..."
```

**Same screen, different content!**

---

## Frontend Architecture

### Screen Structure

```
Dashboard (SwiftUI)
    │
    ├── Investment Catalog
    │       │
    │       └── Catalog Screen (PurchaseCustodyViewController)
    │               │
    │               └── Shows ALL investments (Funds + Royalties)
    │
    ├── Investment Funds Flow (productTypeId: "1")
    │       │
    │       ├── Welcome Screen
    │       ├── Offers List Screen
    │       ├── Offer Detail Screen
    │       ├── Input Value Screen
    │       ├── Confirmation Screen
    │       └── Result Screen
    │
    └── Royalties Flow (productTypeId: "2")
            │
            ├── Welcome Screen (different content)
            ├── Offers List Screen (different offers)
            ├── Offer Detail Screen (different details)
            ├── Input Value Screen
            ├── Confirmation Screen
            └── Result Screen
```

### Technology Stack

- **SwiftUI**: For dashboard and modern UI
- **UIKit**: For complex screens (list, detail, forms)
- **VIPER**: Architecture pattern
- **Deeplinks**: Navigation between screens

### Key Components

#### 1. Dashboard (`DashboardView.swift`)
- First screen users see
- Shows investment type options
- Written in SwiftUI

#### 2. Welcome Screen (`PurchaseWelcomeViewController`)
- Introduces the investment type
- Shows key features
- Has a button to browse offers

#### 3. Offers List (`PurchaseListViewController`)
- Shows all available offers
- User can tap to see details
- Uses UITableView

#### 4. Offer Detail (`PurchaseDetailViewController`)
- Shows detailed information about one offer
- User can invest from here
- Displays documents

#### 5. Input Value (`InsertValueTransferViewController`)
- User enters investment amount
- Validates minimum/maximum values
- Shows quick amount chips

#### 6. Confirmation (`PurchaseConfirmationViewController`)
- Review before purchase
- Shows investment details
- Requires authentication

#### 7. Result (`PurchaseResultViewController`)
- Success/failure screen
- Shows transaction result
- Options to navigate elsewhere

#### 8. Catalog (`PurchaseCatalogViewController`)
- Shows ALL investments from all types
- Uses `PurchaseCustodyViewController` for display
- Allows browsing without selecting a specific product type
- Aggregates offers from Investment Funds and Royalties

#### 9. Custody (`PurchaseCustodyViewController`)
- Displays investment custody and orders
- Shows position information (total invested, yield)
- Filter options: Orders, Custody, All
- Reused by Catalog screen for consistent display

---

## Backend Architecture

### Template-Based API Design

The backend uses a **Template Method Pattern** combined with **Configuration-Driven Architecture** where:

1. **Same endpoints** work for different product types (Multi-Tenant Template System)
2. **productTypeId parameter** determines response content (Configuration-Driven)
3. **Response structure** is consistent across types (Template Method Pattern)
4. **Backend sends structured data** (like `StringToken` with typography) that frontend interprets (Data-Driven Architecture)

### API Endpoints

```
GET /products/{productId}/welcome?productTypeId={productTypeId}
→ Returns welcome screen content for specific product type

GET /products/{productId}/offers?productTypeId={productTypeId}
→ Returns list of offers for specific product type

GET /products/{productId}/offers/{offerId}
→ Returns detailed information about one offer

GET /products/{productId}/offers/{offerId}/rules
→ Returns investment rules (min, max, multiples)

POST /products/{productId}/orders/offers/{offerId}/buy
→ Creates a purchase order
```

### Response Structure

All responses follow a consistent structure:

```json
{
  "data": {
    "id": 1,
    "name": {
      "value": "Product Name",
      "style": "header1"
    },
    "description": {
      "value": "Product description",
      "style": "body1"
    },
    "productType": {
      "id": 1,
      "name": {...}
    }
  }
}
```

### Mock Services

For development, we use **Mock Services** that:
- Return fake data based on productTypeId
- Simulate network delays
- Allow testing without real backend

---

## Design System

### Overview

The Purchase Template uses a **unified design system** that spans across backend, mobile, and the entire application. This ensures consistency in appearance, behavior, and user experience across all platforms and product types.

### Design System Architecture

```
┌─────────────────────────────────────────────────────────┐
│              Backend Design System                      │
│  (StringToken, API Response Structure)                  │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ API Response
                     ▼
┌─────────────────────────────────────────────────────────┐
│            Mobile Design System                         │
│  (Colors, Typography, Spacing, Components)             │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ Renders
                     ▼
┌─────────────────────────────────────────────────────────┐
│              User Interface                             │
│  (Consistent Visual Experience)                         │
└─────────────────────────────────────────────────────────┘
```

### Backend Design System

#### StringToken Structure

The backend sends text content with styling information using `StringToken`:

```json
{
  "name": {
    "value": "Investment Fund ABC",
    "style": "header3"
  },
  "description": {
    "value": "A diversified investment fund...",
    "style": "body1"
  }
}
```

**Structure**:
- `value`: The actual text content (String)
- `style`: Typography style identifier (String) - e.g., "header1", "body1", "note"

**Why This Approach?**
- ✅ Backend controls both content AND styling
- ✅ Consistent typography across all screens
- ✅ Easy to update styles without app updates
- ✅ Supports dynamic theming

#### API Response Structure

All API responses follow a consistent structure:

```json
{
  "data": {
    "id": 1,
    "name": {
      "value": "Product Name",
      "style": "header1"
    },
    "description": {
      "value": "Description text",
      "style": "body1"
    },
    "productType": {
      "id": 1,
      "name": {
        "value": "Investment Funds",
        "style": "header3"
      }
    },
    "information": {
      "metadatas": [
        {
          "id": 1,
          "label": {
            "value": "Minimum Investment",
            "style": "label"
          },
          "value": {
            "value": "R$ 1.000,00",
            "style": "body2"
          }
        }
      ]
    }
  }
}
```

**Key Features**:
- Consistent `data` wrapper
- All text uses `StringToken` format
- Nested structures for complex data
- Metadata arrays for flexible information display

### Mobile Design System

#### Color System

The mobile app uses a semantic color system:

```swift
enum Color {
    // Primary Colors
    case primary900  // #1A1A1A - Darkest primary
    case primary800  // #333333 - Dark primary
    case primary500  // #21C25E - Main brand color (green)
    case primary200  // #E8F5EE - Light primary
    
    // Grayscale
    case grayScale900  // #1A1A1A - Text primary
    case grayScale800  // #666666 - Text secondary
    case grayScale200  // #E5E5E5 - Borders/separators
    
    // Feedback Colors
    case feedbackSuccess500  // #21C25E - Success states
    case feedbackWarning500  // #FF6B35 - Warning/error states
    
    // Background Colors
    case background00  // White background
    case white
    case black
}
```

**Color Usage**:
- **Primary Colors**: Brand identity, primary actions, highlights
- **Grayscale**: Text, borders, backgrounds
- **Feedback Colors**: Success messages, error states, warnings

**Opacity Levels**:
```swift
enum OpacityLevel {
    case light   // 0.1 alpha - Subtle backgrounds
    case medium  // 0.5 alpha - Overlays
    case heavy   // 0.8 alpha - Strong overlays
}
```

#### Typography System

Typography is controlled by the `PurchaseTypograph` enum, which maps backend style strings to mobile fonts:

```swift
enum PurchaseTypograph: String {
    case header1, header2, header3, header4, header5
    case body1, body2, body3
    case note, notePositive, noteNegative
}
```

**Font Mapping**:

| Typograph | Font Size | Weight | Use Case |
|-----------|-----------|--------|----------|
| header1 | 28pt | Bold | Main titles |
| header2 | 22pt | Semibold | Section titles |
| header3 | 18pt | Medium | Card titles |
| header4 | 18pt | Medium | Subsection titles |
| header5 | 22pt | Semibold | Alternative headers |
| body1 | 18pt | Regular | Main content |
| body2 | 18pt | Regular (highlighted) | Emphasized content |
| body3 | 18pt | Regular (highlighted) | Links/actions |
| note | 16pt | Regular | Secondary text |
| notePositive | 16pt | Regular (highlighted) | Success messages |
| noteNegative | 16pt | Regular (highlighted) | Error messages |

**Color Mapping**:
- Headers (h1-h3): `primary900` (dark)
- Header4: `primary800` (medium dark)
- Body1: `grayScale800` (medium gray)
- Body2: `grayScale900` (dark)
- Body3: `primary500` (brand green)
- Notes: `grayScale900` (dark)
- Positive notes: `feedbackSuccess500` (green)
- Negative notes: `feedbackWarning500` (orange)

#### Spacing System

Consistent spacing using the `Space` enum:

```swift
enum Space: CGFloat {
    case base00 = 4   // Smallest spacing
    case base02 = 8   // Small spacing
    case base03 = 12  // Medium-small spacing
    case base04 = 16  // Medium spacing
    case base06 = 24  // Large spacing
    case base07 = 28  // Large-medium spacing
    case base08 = 32  // Extra large spacing
    case base10 = 40  // Very large spacing
    case base12 = 48  // Maximum spacing
}
```

**Usage Guidelines**:
- `base00` (4pt): Tight spacing, chip padding
- `base02` (8pt): Standard element spacing
- `base04` (16pt): Card padding, section spacing
- `base06` (24pt): Large section spacing
- `base12` (48pt): Maximum spacing, footer heights

#### Border Radius System

```swift
enum Radius {
    case small   // 4pt - Small elements
    case medium  // 8pt - Standard elements
    case large   // 12pt - Cards, containers
    case strong  // 16pt - Large containers
}
```

#### Icon System

Icons use SF Symbols with semantic naming:

```swift
enum Icon: String {
    case infoCircle
    case invoice
    case documentInfo
    case angleRightB          // Chevron right
    case filter
    case shieldCheckmark      // Security
    case chartLineUptrend     // Growth/charts
    case questionmarkCircle   // Help/FAQ
    case docText              // Documents
}
```

**Usage**:
- Consistent iconography across the app
- SF Symbols for native iOS look
- Semantic names for easy understanding

#### Component System

##### Button Component

```swift
class Button: UIButton {
    enum Style {
        case primary    // Green background, white text
        case secondary  // Transparent, green border
        case tertiary   // Text only, green text
    }
}
```

**Styles**:
- **Primary**: Main actions (Invest, Confirm)
- **Secondary**: Alternative actions
- **Tertiary**: Text-only actions

##### Avatar Component

```swift
class Avatar: UIImageView {
    enum AvatarSize {
        case small   // 32pt
        case medium  // 40pt
        case large   // 56pt
    }
    
    enum AvatarStyle {
        case circle
        case square
    }
}
```

##### Chips Component

```swift
class Chips: UIView {
    init(isToogle: Bool = false)
    func selected(_ value: Bool) -> Chips
    func text(_ text: String) -> Chips
    func action(_ handler: @escaping (Bool) -> Void) -> Chips
}
```

**Usage**: Filter chips, selection chips, toggle chips

### Design System Integration

#### How Backend and Mobile Work Together

1. **Backend sends StringToken**:
   ```json
   {
     "name": {
       "value": "Investment Fund",
       "style": "header3"
     }
   }
   ```

2. **Mobile receives and converts**:
   ```swift
   let stringToken = StringToken(value: "Investment Fund", style: "header3")
   let typograph = PurchaseTypograph(rawValue: "header3") // → .header3
   ```

3. **Mobile applies styling**:
   ```swift
   textLabel.font = typograph.font        // → 18pt Medium
   textLabel.textColor = typograph.color  // → primary900
   ```

4. **Result**: Consistent appearance across all screens!

#### Layout Styles

The backend can specify different layout styles for the same screen:

**Style 1: Card-Based Layout**
- Used for: Offer lists, investment cards
- Features: Rounded corners, shadows, padding

**Style 2: List-Based Layout**
- Used for: Simple lists, metadata display
- Features: Minimal styling, clear separation

**Style 3: Custody Layout**
- Used for: Catalog, custody screens
- Features: Header with position info, filter chips, detailed cards

**How it works**: The backend includes layout hints in the response, and the mobile app adapts the UI accordingly.

### Design Tokens Summary

| Category | Backend | Mobile | Purpose |
|----------|---------|--------|---------|
| **Typography** | `style: "header1"` | `PurchaseTypograph.header1` | Text appearance |
| **Colors** | N/A (mobile controlled) | `Color.primary500` | Visual identity |
| **Spacing** | N/A (mobile controlled) | `Space.base04` | Layout consistency |
| **Icons** | Icon names | `Icon.questionmarkCircle` | Visual communication |
| **Components** | Component types | `Button`, `Avatar`, `Chips` | Reusable UI elements |

### Design System Benefits

✅ **Consistency**: Same look and feel across all screens  
✅ **Maintainability**: Change styles in one place  
✅ **Scalability**: Easy to add new styles  
✅ **Backend Control**: Backend can influence styling  
✅ **Type Safety**: Compile-time checks for design tokens  
✅ **Reusability**: Components work across product types  

---

## Flow Diagrams

### Complete Purchase Flow

```
┌─────────────┐
│  Dashboard  │
│  (Select    │
│   Type)     │
└──────┬──────┘
       │
       ├──────────────┬───────────────┐
       │              │               │
       ▼              ▼               ▼
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│ Investment  │  │  Royalties  │  │   Catalog   │
│   Funds     │  │ Investment  │  │  (All Types)│
│ (Type: "1") │  │ (Type: "2") │  │             │
└──────┬──────┘  └──────┬──────┘  └──────┬──────┘
       │                 │                 │
       │                 │                 │ (Uses Custody View)
       │                 │                 │
       └────────┬────────┘                 │
                │                          │
                ▼                          │
        ┌───────────────┐                  │
        │ Welcome Screen│                  │
        │ (Adapts based │                  │
        │  on type)     │                  │
        └───────┬───────┘                  │
                │                          │
                ▼                          │
        ┌───────────────┐                  │
        │ Offers List   │                  │
        │ (Shows offers │                  │
        │  for type)    │                  │
        └───────┬───────┘                  │
                │                          │
                ▼                          │
        ┌───────────────┐                  │
        │ Offer Detail  │◄─────────────────┘
        │ (Full details)│   (Can navigate from Catalog)
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │ Input Value   │
        │ (Enter amount)│
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │ Confirmation  │
        │ (Review & Auth)│
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │ Result Screen │
        │ (Success/Fail)│
        └───────────────┘
```

### Data Flow (VIPER)

```
User Action
    │
    ▼
┌──────────┐
│   View   │ ──(user taps button)──┐
└────┬─────┘                        │
     │                              │
     ▼                              │
┌──────────────┐                    │
│  Presenter   │ ──(formats data)──┐│
└────┬─────────┘                    ││
     │                              ││
     ▼                              ││
┌──────────────┐                    ││
│ Interactor   │ ──(business logic)─┐││
└────┬─────────┘                    │││
     │                              │││
     ▼                              │││
┌──────────────┐                    │││
│   Service    │ ──(API call)───────┐│││
└────┬─────────┘                    ││││
     │                              ││││
     ▼                              ││││
┌──────────────┐                    ││││
│   Backend    │                    ││││
└──────────────┘                    ││││
     │                              ││││
     └──(Response)───────────────────┘│││
         │                            │││
         └──(Data)────────────────────┘││
             │                          ││
             └──(Formatted)─────────────┘│
                 │                        │
                 └──(Displayed)───────────┘
```

---

## Key Concepts

### 1. productTypeId

**What it is**: A string identifier that tells the app which type of investment we're dealing with.

**Values**:
- `"1"` = Investment Funds
- `"2"` = Royalties Investment

**How it's used**:
- Passed from Dashboard → Welcome → List → Detail
- Determines what content to show
- Determines what API data to fetch

### 2. Deeplinks

**What it is**: URLs that navigate between screens within the app.

**Example**:
```
purchasetemplate://purchase/offers?productId=1&productTypeId=2
```

**How it works**:
1. User taps button
2. App creates deeplink URL
3. Deeplink handler opens correct screen
4. Screen extracts parameters from URL

### 3. Mock Services

**What it is**: Fake backend services for development.

**Why use it**:
- Test without real backend
- Work offline
- Control test data
- Faster development

**How it works**:
- Intercepts API calls
- Returns predefined data based on productTypeId
- Simulates network delays

### 4. StringToken

**What it is**: A structure that contains both text and styling information.

**Structure**:
```swift
StringToken(
    value: "Hello World",
    style: "header1"
)
```

**Why use it**:
- Backend controls both content AND styling
- Consistent typography
- Easy to change styles

**How it works**:
1. Backend sends `StringToken` in API response
2. Mobile converts to `StringWithTypograph`
3. `PurchaseTypograph` maps style string to font/color
4. UI component applies styling automatically

### 5. Catalog Screen

**What it is**: A unified screen that displays ALL investments regardless of type.

**Features**:
- Shows investments from both Investment Funds and Royalties
- Uses `PurchaseCustodyViewController` for consistent display
- Allows browsing without selecting a specific product type
- Aggregates offers from multiple sources

**Implementation**:
- `PurchaseCatalogService` fetches from `/catalog` endpoint
- `PurchaseCatalogInteractor` conforms to `PurchaseCustodyInteracting`
- `PurchaseCatalogPresenter` creates `PurchaseCustodyDTO`
- Reuses custody view components for display

---

## Implementation Details

### How Screens Adapt to Product Type

#### Step 1: Dashboard Selection
```swift
// User selects "Royalties Investment"
NavigationLink(
    destination: PurchaseWelcomeViewWrapper(
        productId: "2", 
        productTypeId: "2"  // ← This is the key!
    )
)
```

#### Step 2: Welcome Screen Receives productTypeId
```swift
// PurchaseWelcomeService fetches data
service.getWelcomeData(
    productId: "2",
    productTypeId: "2"  // ← Passed to API
)
```

#### Step 3: Mock Service Returns Type-Specific Data
```swift
// PurchaseWelcomeFixture checks productTypeId
if productTypeId == "2" {
    // Return Royalties content
    return RoyaltiesWelcomeData()
} else {
    // Return Funds content
    return FundsWelcomeData()
}
```

#### Step 4: Screen Displays Appropriate Content
```swift
// Presenter formats data
// View displays it
// User sees Royalties-specific content!
```

### Adding a New Product Type

To add a new product type (e.g., "Stocks"):

1. **Add to Dashboard**:
```swift
NavigationLink(
    destination: PurchaseWelcomeViewWrapper(
        productId: "3", 
        productTypeId: "3"
    )
) {
    MenuCard(title: "Stocks Investment", ...)
}
```

2. **Update Fixtures**:
```swift
// In PurchaseWelcomeFixture.swift
if productTypeId == "3" {
    return StocksWelcomeData()
}
```

3. **Add Product Type ID**:
```swift
// In TypeSafeIDs.swift
enum ProductTypeID {
    case investmentFunds = "1"
    case royaltiesInvestment = "2"
    case stocksInvestment = "3"  // ← New!
}
```

That's it! The template handles the rest.

---

## Layout Styles

### Different Layout Styles for Same Screen

The template supports different visual layouts for the same screen:

#### Style 1: Card-Based Layout
```
┌─────────────────┐
│   Card 1        │
├─────────────────┤
│   Card 2        │
├─────────────────┤
│   Card 3        │
└─────────────────┘
```

#### Style 2: List-Based Layout
```
┌─────────────────┐
│ Item 1          │
├─────────────────┤
│ Item 2          │
├─────────────────┤
│ Item 3          │
└─────────────────┘
```

#### Style 3: Grid Layout
```
┌─────┬─────┬─────┐
│  A  │  B  │  C  │
├─────┼─────┼─────┤
│  D  │  E  │  F  │
└─────┴─────┴─────┘
```

**How it works**: The backend can specify which layout style to use, and the frontend adapts accordingly.

---

## Getting Started

### Prerequisites

- Xcode 14.0+
- iOS 15.0+
- Swift 5.7+

### Project Structure

```
PurchaseTemplate/
├── PurchaseTemplate/
│   ├── Core/                    # Core utilities
│   │   ├── TypeSafeIDs.swift
│   │   └── ErrorHandler.swift
│   ├── Purchase/                # Purchase flow modules
│   │   ├── Welcome/            # Welcome screen
│   │   ├── OffersList/         # List of offers
│   │   ├── OfferDetail/        # Offer details
│   │   ├── InputValue/         # Amount input
│   │   ├── Confirmation/       # Purchase confirmation
│   │   └── Result/             # Result screen
│   ├── Mocks/                   # Mock implementations
│   │   ├── MockProtocols.swift
│   │   ├── MockDependencyContainer.swift
│   │   ├── MockUIComponents.swift
│   │   └── Fixtures/           # Mock data
│   ├── DashboardView.swift     # Main dashboard
│   └── ContentView.swift       # App entry point
└── Apollo/                      # Reference framework (not used)
```

### Running the App

1. Open `PurchaseTemplate.xcodeproj`
2. Select a simulator (iPhone 14 Pro recommended)
3. Press ⌘R to run
4. You'll see the Dashboard with two investment options

### Testing Different Flows

1. **Investment Funds Flow**:
   - Tap "Investment Funds" on Dashboard
   - Follow through the purchase flow
   - Notice Funds-specific content

2. **Royalties Flow**:
   - Tap "Royalties Investment" on Dashboard
   - Follow through the purchase flow
   - Notice Royalties-specific content (different text, different offers)

---

## Best Practices

### 1. Always Pass productTypeId

When navigating between screens, always include `productTypeId`:

```swift
// ✅ Good
coordinator.navigateToDetail(
    offerId: "1",
    productId: "1",
    productTypeId: "2"  // ← Don't forget!
)

// ❌ Bad
coordinator.navigateToDetail(
    offerId: "1",
    productId: "1"
    // Missing productTypeId!
)
```

### 2. Use Type-Safe IDs

Instead of strings, use type-safe identifiers:

```swift
// ✅ Good
let productType: ProductTypeID = .royaltiesInvestment
let productId = ProductID("1")

// ❌ Bad
let productType = "2"
let productId = "1"
```

### 3. Handle Errors Consistently

Use the standardized error handler:

```swift
// ✅ Good
handleError(error) { [weak self] in
    self?.retry()
}

// ❌ Bad
// Custom error handling everywhere
```

---

## FAQ

### Q: Can I add more product types?

**A**: Yes! Just:
1. Add new option to Dashboard
2. Update fixtures to return data for new type
3. Add new ProductTypeID enum case

### Q: How do I change the layout style?

**A**: The backend can specify layout style in the response. The frontend will adapt automatically.

### Q: Can I customize individual screens?

**A**: Yes! Each screen module is independent. You can customize:
- Colors
- Fonts
- Layout
- Behavior

### Q: How do I connect to a real backend?

**A**: Replace `MockCoreService` with real API implementation. The interface stays the same!

---

## Conclusion

Purchase Template is a powerful, flexible system that allows you to:
- ✅ Support multiple product types with one codebase
- ✅ Maintain consistent user experience
- ✅ Easily add new product types
- ✅ Customize layouts and styles
- ✅ Reuse screens across different products

The template approach saves time, reduces code duplication, and makes maintenance easier.

---

## Additional Resources

### Code Examples

See the following files for implementation examples:
- `DashboardView.swift` - Dashboard implementation
- `PurchaseWelcomeViewController.swift` - Welcome screen
- `PurchaseListViewController.swift` - List screen
- `MockDependencyContainer.swift` - Mock service implementation

### Architecture Patterns

- **VIPER**: See any module in `Purchase/` folder
- **Dependency Injection**: See `MockDependencyContainer.swift`
- **Template Pattern**: See how fixtures adapt to productTypeId

---

**Document Version**: 2.0  
**Last Updated**: January 2025  
**Author**: Purchase Template Team

### Recent Updates

**Version 2.0** (January 2025):
- ✅ Added Catalog screen documentation
- ✅ Added comprehensive Design System section
- ✅ Updated flow diagrams to include Catalog
- ✅ Documented backend-mobile design system integration
- ✅ Added custody view controller reuse information


