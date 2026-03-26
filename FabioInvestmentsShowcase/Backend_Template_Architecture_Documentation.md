# Backend Template Architecture Documentation

## Overview

The Investments module implements a sophisticated **Backend Template Architecture** that allows the backend to control content, styling, and structure dynamically without requiring app updates. This system uses **StringToken** and **Metadata-driven rendering** to create flexible, maintainable user interfaces.

## Architecture Components

### 1. StringToken System

The core of the backend template architecture is the `StringToken` structure that combines content with styling information.

```swift
public struct StringToken: Decodable, Equatable {
    let value: String      // The actual text content from backend
    let style: String      // The typography style identifier from backend
}
```

#### Example Backend Response:
```json
{
  "name": {
    "value": "Investimento em Renda Fixa",
    "style": "header2"
  },
  "description": {
    "value": "Aplique seu dinheiro com segurança e rentabilidade",
    "style": "body1"
  }
}
```

### 2. Typography System

The `PurchaseTypograph` enum defines the available styles and their visual properties:

```swift
public enum PurchaseTypograph: String, Equatable {
    case header1, header2, header3, header4, header5
    case body1, body2, body3
    case note, notePositive, noteNegative
}
```

Each typograph includes:
- **Color mapping** (primary900, grayScale800, etc.)
- **Font mapping** (Font.large, Font.medium, Font.body, etc.)

### 3. Template Conversion

The `StringWithTypograph` struct converts backend tokens to UI-ready format:

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

## Implementation Flows

### 1. Purchase Welcome Flow

**Location**: `Modules/Features/Investments/Investments/Scenes/Purchase/Welcome/`

#### Backend Data Structure:
```swift
struct PurchaseWelcomeModel: Decodable, Equatable {
    let productId: Int
    let productTypeId: Int
    let name: StringToken                    // Backend template
    let description: StringToken            // Backend template
    let nextDeepLinkName: StringToken       // Backend template
    let nextDeepLink: String
    let imageUrl: String
    let items: [MenuItem]                   // Backend template array
}

struct MenuItem: Decodable, Equatable {
    let name: StringToken                   // Backend template
    let description: StringToken            // Backend template
    let nextDeepLink: String
    let imageIcon: String
}
```

#### Template Processing:
```swift
private func createDTO(with model: PurchaseWelcomeServicingModel.PurchaseWelcomeModel) -> PurchaseWelcomeDTO {
    // Convert backend StringToken to UI components
    let header = PurchaseWelcomeDTO.Header(
        title: .init(stringToken: model.name),           // Backend → UI
        description: .init(stringToken: model.description), // Backend → UI
        imageUrl: model.imageUrl
    )
    
    // Process dynamic menu items from backend
    let items = model.items.map { data in
        PurchaseWelcomeDTO.ListItem(
            icon: data.imageIcon,
            title: .init(stringToken: data.name),        // Backend → UI
            description: .init(stringToken: data.description) // Backend → UI
        )
    }
    
    // Dynamic button from backend
    let confirmButton = PurchaseWelcomeDTO.ActionButton(
        label: model.nextDeepLinkName.value,
        style: PurchaseWelcomeDTO.ActionButton.Style(rawValue: model.nextDeepLinkName.style) ?? .PrimaryMedium,
        action: model.nextDeepLink
    )
    
    return .init(header: header, listItems: items, footer: footer)
}
```

### 2. Purchase Detail Flow

**Location**: `Modules/Features/Investments/Investments/Scenes/Purchase/OfferDetail/`

#### Backend Data Structure:
```swift
struct PurchaseProductModel: Decodable, Equatable {
    let id: Int
    let name: StringToken                    // Backend template
    let description: StringToken?           // Backend template
    let imageIcon: String?
    let status: Status
    let product: Product
    let productType: ProductType
    let information: Information            // Metadata-driven content
    let externalCode: String
    let assetSymbol: String
    let documents: [Document]?
}

struct Information: Decodable, Equatable {
    let metadatas: [MetaData]               // Backend template fields
    let groups: [Group]?                    // Hierarchical metadata
}

struct MetaData: Decodable, Equatable {
    let id: Int
    let label: StringToken                  // Backend template
    let description: StringToken?           // Backend template
    let value: StringToken?                 // Backend template
    let externalCode: String
}
```

#### Metadata Processing:
```swift
// Process flat metadata from backend
private func generateMetadataFields(on metadata: [PurchaseProductModel.MetaData]) -> [PurchaseDetailDTO.Field] {
    let fieldsMetadata: [PurchaseDetailDTO.Field] = metadata.map { metadata in
        PurchaseDetailDTO.Field(
            label: StringWithTypograph(stringToken: metadata.label),    // Backend → UI
            value: StringWithTypograph(
                value: metadata.value?.value ?? "", 
                typograph: metadata.value?.style ?? ""                 // Backend → UI
            )
        )
    }
    return fieldsMetadata
}

// Process hierarchical metadata groups
private func generateGroupMetadataFields(_ group: PurchaseProductModel.Group) -> [PurchaseDetailDTO.Section] {
    var sections = [PurchaseDetailDTO.Section]()
    
    // Process group metadata
    if let metadataSection = group.metadatas.map({ metadata in
        PurchaseDetailDTO.Section(
            title: group.name.value, 
            rows: generateMetadataFields(on: metadata)  // Recursive processing
        )
    }) {
        sections.append(metadataSection)
    }
    
    // Process nested groups recursively
    _ = group.groups.map { result in
        result.map { result in
            let groupMetadataSection = generateGroupMetadataFields(result)
            sections.append(contentsOf: groupMetadataSection)
        }
    }
    
    return sections
}
```

### 3. Purchase Custody Flow

**Location**: `Modules/Features/Investments/Investments/Scenes/Purchase/Custody/`

#### Backend Data Structure:
```swift
struct PurchaseCustodyService {
    struct Response: Decodable, Equatable {
        let data: [PurchaseProductModel]    // Array of products with metadata
    }
    
    struct PositionResponse: Decodable, Equatable {
        let data: TotalPosition
        
        struct TotalPosition: Decodable, Equatable {
            let total: TotalPositionValue
        }
        
        struct TotalPositionValue: Decodable, Equatable {
            let value: Token                 // Backend template
            let yield: Token                 // Backend template
            
            struct Token: Decodable, Equatable {
                let label: StringToken       // Backend template
                let description: StringToken? // Backend template
                let value: StringToken?      // Backend template
            }
        }
    }
}
```

#### Dynamic Card Generation:
```swift
private func createDTO(
    with model: [PurchaseProductModel],
    position: PurchaseCustodyService.PositionResponse.TotalPositionValue,
    isCustodyFilter: Bool
) -> PurchaseCustodyDTO {
    
    // Generate dynamic cards from backend metadata
    let cards = model.map { data in
        let fields: [PurchaseCustodyDTO.Field] = data.information.metadatas.map { metadata in
            PurchaseCustodyDTO.Field(
                label: StringWithTypograph(stringToken: metadata.label),    // Backend → UI
                value: StringWithTypograph(
                    value: metadata.value?.value ?? "",
                    typograph: metadata.value?.style ?? ""                 // Backend → UI
                )
            )
        }
        return PurchaseCustodyDTO.Card(
            title: StringWithTypograph(stringToken: data.name),            // Backend → UI
            fields: fields
        )
    }
    
    // Process position data from backend
    let header = PurchaseCustodyDTO.Header(
        left: .init(
            label: StringWithTypograph(stringToken: position.value.label),    // Backend → UI
            value: StringWithTypograph(stringToken: position.value.value!)
        ),
        right: .init(
            label: StringWithTypograph(stringToken: position.yield.label),    // Backend → UI
            value: StringWithTypograph(stringToken: position.yield.value!)
        )
    )
    
    return .init(title: title, header: header, detail: detail, cards: cards)
}
```

### 4. Purchase Confirmation Flow

**Location**: `Modules/Features/Investments/Investments/Scenes/Purchase/Confirmation/`

#### Field-based Template Processing:
```swift
func setupDTO(with model: PurchaseOrderModel) -> PurchaseConfirmationDTO {
    // Generate fields with backend typography
    let originalValue = PurchaseConfirmationDTO.Field(
        label: StringWithTypograph(value: strings.originalValue, typograph: ""),
        value: StringWithTypograph(
            value: model.value.toCurrencyString() ?? "", 
            typograph: "body2"  // Backend template style
        )
    )
    
    let quantity = PurchaseConfirmationDTO.Field(
        label: StringWithTypograph(value: strings.quantity, typograph: ""),
        value: StringWithTypograph(
            value: String(model.quantity), 
            typograph: "body2"  // Backend template style
        )
    )
    
    let value = PurchaseConfirmationDTO.Field(
        label: StringWithTypograph(value: strings.value, typograph: ""),
        value: StringWithTypograph(
            value: model.tokenValue.toCurrencyString() ?? "", 
            typograph: "body2"  // Backend template style
        )
    )
    
    return PurchaseConfirmationDTO(
        title: StringWithTypograph(value: strings.title, typograph: "header2"),
        button: strings.button,
        fields: [originalValue, type, product]
    )
}
```

## Data Flow Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Backend API   │───▶│   StringToken    │───▶│ StringWithTypo  │───▶│   UI Components │
│                 │    │                  │    │     graph       │    │                 │
│ • Content       │    │ • value: String  │    │ • Typography    │    │ • Text Views    │
│ • Styling       │    │ • style: String  │    │ • Colors        │    │ • Labels        │
│ • Structure     │    │                  │    │ • Fonts         │    │ • Buttons       │
└─────────────────┘    └──────────────────┘    └─────────────────┘    └─────────────────┘
```

## Template Processing Pipeline

### 1. Backend Response Processing
```swift
// API Response with StringToken
struct BackendResponse {
    let title: StringToken
    let description: StringToken
    let metadata: [MetaData]
}
```

### 2. Token Conversion
```swift
// Convert StringToken to UI-ready format
let title = StringWithTypograph(stringToken: backendResponse.title)
let description = StringWithTypograph(stringToken: backendResponse.description)
```

### 3. UI Rendering
```swift
// Apply typography to UI components
titleText.setTypograph(title.typograph)
descriptionText.setTypograph(description.typograph)
```

## Metadata Processing Patterns

### 1. Flat Metadata Processing
```swift
// Process simple key-value pairs from backend
let fields = metadata.map { item in
    Field(
        label: StringWithTypograph(stringToken: item.label),
        value: StringWithTypograph(stringToken: item.value)
    )
}
```

### 2. Hierarchical Metadata Processing
```swift
// Process nested metadata groups
func processGroups(_ groups: [Group]) -> [Section] {
    return groups.flatMap { group in
        var sections = [Section]()
        
        // Process group metadata
        if let groupFields = group.metadatas {
            sections.append(Section(
                title: group.name.value,
                rows: processMetadata(groupFields)
            ))
        }
        
        // Process nested groups recursively
        if let nestedGroups = group.groups {
            sections.append(contentsOf: processGroups(nestedGroups))
        }
        
        return sections
    }
}
```

### 3. Dynamic Card Generation
```swift
// Generate cards from backend product data
let cards = products.map { product in
    Card(
        title: StringWithTypograph(stringToken: product.name),
        fields: product.metadata.map { meta in
            Field(
                label: StringWithTypograph(stringToken: meta.label),
                value: StringWithTypograph(stringToken: meta.value)
            )
        }
    )
}
```

## Benefits of Backend Template Architecture

### 1. **Dynamic Content Control**
- Backend controls all text content and styling
- Real-time content updates without app releases
- A/B testing capabilities for content

### 2. **Consistent Typography**
- Centralized typography system
- Consistent visual hierarchy
- Easy maintenance of design system

### 3. **Flexible Structure**
- Backend defines content structure
- Support for hierarchical metadata
- Dynamic field generation

### 4. **Maintainability**
- Content changes don't require app updates
- Centralized content management
- Reduced development overhead

### 5. **Performance**
- Efficient template processing
- Reusable components
- Optimized rendering pipeline

## Best Practices

### 1. **Token Design**
- Use semantic style names (header1, body1, etc.)
- Maintain consistent typography hierarchy
- Document style usage guidelines

### 2. **Metadata Structure**
- Design hierarchical metadata for complex content
- Use consistent field naming conventions
- Implement proper validation on backend

### 3. **Template Processing**
- Implement efficient conversion pipelines
- Handle missing or invalid tokens gracefully
- Provide fallback typography styles

### 4. **Error Handling**
- Validate backend responses
- Provide default content for missing data
- Log template processing errors

## Comparison with SDUI

| Aspect | Backend Template (Non-SDUI) | SDUI |
|--------|------------------------------|------|
| **View Rendering** | Custom UI components | BankingUI components |
| **Content Control** | StringToken + Typography | BankingSDUIDynamic |
| **Layout Control** | Fixed layout, dynamic content | Dynamic layout + content |
| **Styling** | PurchaseTypograph system | BankingUI theme system |
| **Complexity** | Medium complexity | High complexity |
| **Flexibility** | Content flexibility | Full UI flexibility |
| **Performance** | High performance | Medium performance |
| **Maintenance** | Easy maintenance | Complex maintenance |

## Conclusion

The Backend Template Architecture provides a powerful and flexible way to create dynamic, maintainable user interfaces. By leveraging StringToken and metadata-driven rendering, the system enables backend control over content and styling while maintaining excellent performance and developer experience.

This architecture is particularly well-suited for:
- Content-heavy applications
- A/B testing scenarios
- Multi-tenant applications
- Rapid content iteration
- Design system consistency

The implementation in the Investments module demonstrates how this architecture can be effectively used to create sophisticated, dynamic user interfaces that are both maintainable and performant.
