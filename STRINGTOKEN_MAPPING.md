# StringToken Mapping Flow - Complete Documentation

## Overview

This document explains exactly where and how `StringToken(value: "Hello World", style: "header1")` is mapped/converted to styled UI components.

---

## Complete Mapping Flow

### Step 1: Backend/API Returns StringToken

```swift
// From API Response (JSON decoded)
StringToken(
    value: "Hello World",
    style: "header1"  // ← String from backend
)
```

**Location**: `PurchaseWelcomeService.swift`, `PurchaseListService.swift`, etc.
- The API returns JSON with `value` and `style` fields
- Swift's `Decodable` automatically creates `StringToken` structs

---

### Step 2: Presenter Converts StringToken → StringWithTypograph

**Location**: `PurchaseTypograph.swift` (Lines 66-69)

```swift
public struct StringWithTypograph {
    var value: String
    var typograph: PurchaseTypograph  // ← Enum, not string!
    
    public init(stringToken: StringToken) {
        self.value = stringToken.value  // "Hello World"
        // Convert string style to PurchaseTypograph enum
        self.typograph = PurchaseTypograph(rawValue: stringToken.style) ?? .body1
        // "header1" → PurchaseTypograph.header1
    }
}
```

**Where this happens**:
- `PurchaseWelcomePresenter.swift` (Line 28-29)
- `PurchaseListPresenter.swift` (Line 33, 36)
- `PurchaseDetailPresenter.swift` (Line 30, 82)
- `PurchaseCustodyPresenter.swift` (Line 38, 46, 58, 62)

**Example**:
```swift
// In PurchaseWelcomePresenter
let title = StringWithTypograph(stringToken: model.name)
// StringToken(value: "Hello", style: "header1")
//   ↓
// StringWithTypograph(value: "Hello", typograph: .header1)
```

---

### Step 3: StringWithTypograph Added to DTO

**Location**: Presenter files create DTOs with `StringWithTypograph`

```swift
// PurchaseWelcomeDTO
struct PurchaseWelcomeDTO {
    let title: StringWithTypograph  // ← Contains value + typograph enum
    let description: StringWithTypograph
    // ...
}
```

---

### Step 4: View Receives DTO and Extracts Typograph

**Location**: View files (e.g., `PurchaseWelcomeView.swift`, `PurchaseListTableViewCell.swift`)

```swift
// In PurchaseWelcomeView.setup()
titleText.value = dto.title.value  // "Hello World"
titleText.setTypograph(dto.title.typograph)  // PurchaseTypograph.header1
```

---

### Step 5: setTypograph Applies Styling

There are **TWO** `setTypograph` methods:

#### A. setTypograph(String) - Converts String to PurchaseTypograph

**Location**: `MockMissingTypes.swift` (Lines 115-134)

```swift
extension Text {
    func setTypograph(_ typograph: String) {
        // Convert string "header1" to PurchaseTypograph.header1
        if let purchaseTypograph = PurchaseTypograph(rawValue: typograph) {
            setTypograph(purchaseTypograph)  // Calls method B
        } else {
            // Fallback styling
        }
    }
}
```

**Used in**: 
- `PurchaseListTableViewCell.swift` (Line 74, 79)
- `PurchaseDetailTableViewCell.swift` (Line 128, 133)
- When passing `typograph.rawValue` (string)

#### B. setTypograph(PurchaseTypograph) - Applies Font & Color

**Location**: `PurchaseTypograph.swift` (Lines 72-76)

```swift
extension Text {
    public func setTypograph(_ typograph: PurchaseTypograph) {
        font(typograph.font)           // ← Gets font from enum
        foreground(color: typograph.color)  // ← Gets color from enum
    }
}
```

**Used in**:
- `PurchaseWelcomeView.swift` (Line 119, 123)
- `PurchaseWelcomeCardView.swift` (Line 51, 53)
- `PurchaseListHeaderView.swift` (Line 50, 52)
- When passing `PurchaseTypograph` enum directly

---

### Step 6: PurchaseTypograph Enum Maps Style → Font & Color

**Location**: `PurchaseTypograph.swift` (Lines 3-54)

```swift
public enum PurchaseTypograph: String {
    case header1
    case header2
    // ...
    
    var color: Color {
        switch self {
        case .header1, .header2, .header3:
            return .primary900  // ← Dark color
        case .header4:
            return .primary800
        // ...
        }
    }
    
    var font: any FontStyle {
        switch self {
        case .header1:
            return Font.large  // ← 28pt bold
        case .header2, .header5:
            return Font.medium  // ← 22pt semibold
        // ...
        }
    }
}
```

---

### Step 7: Font & Color Applied to UILabel

**Location**: `MockUIComponents.swift` (Lines 109-124)

```swift
class Text: UILabel {
    func font(_ fontStyle: FontStyle) -> Self {
        self.font = fontStyle.uiFont  // ← UIFont.systemFont(ofSize: 28, weight: .bold)
        return self
    }
    
    func foreground(color: Color) -> Self {
        self.textColor = color.uiColor  // ← UIColor(hex: "#1A1A1A")
        return self
    }
}
```

---

## Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Backend/API                                              │
│    Returns: StringToken(value: "Hello", style: "header1")  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. PurchaseTypograph.swift (Line 66-69)                     │
│    StringWithTypograph(stringToken: token)                   │
│    Converts: "header1" string → PurchaseTypograph.header1   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. Presenter (e.g., PurchaseWelcomePresenter)               │
│    Creates DTO with StringWithTypograph                      │
│    DTO.title = StringWithTypograph(value: "Hello",          │
│                                    typograph: .header1)     │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. View (e.g., PurchaseWelcomeView)                         │
│    Receives DTO                                              │
│    titleText.value = dto.title.value                        │
│    titleText.setTypograph(dto.title.typograph)              │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 5a. MockMissingTypes.swift (Line 115)                       │
│     setTypograph(String) - if passing rawValue               │
│     Converts string → PurchaseTypograph enum                 │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 5b. PurchaseTypograph.swift (Line 73)                       │
│     setTypograph(PurchaseTypograph)                         │
│     font(typograph.font)                                    │
│     foreground(color: typograph.color)                       │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. PurchaseTypograph Enum (Lines 16-54)                     │
│    .header1.color → Color.primary900                        │
│    .header1.font → Font.large                               │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 7. MockUIComponents.swift (Lines 109-124)                   │
│    Text.font() → Sets UILabel.font                          │
│    Text.foreground() → Sets UILabel.textColor               │
└─────────────────────────────────────────────────────────────┘
                     │
                     ▼
              ┌──────────────┐
              │  UILabel     │
              │  Shows:      │
              │  "Hello"     │
              │  (28pt bold, │
              │   dark gray) │
              └──────────────┘
```

---

## Key Files and Locations

### 1. StringToken Definition
**File**: `PurchaseWelcomeService.swift` (Line 37-40)
```swift
public struct StringToken: Decodable, Equatable {
    let value: String
    let style: String  // ← Raw string from backend
}
```

### 2. StringWithTypograph Conversion
**File**: `PurchaseTypograph.swift` (Lines 57-70)
```swift
public struct StringWithTypograph {
    var value: String
    var typograph: PurchaseTypograph  // ← Enum
    
    public init(stringToken: StringToken) {
        self.value = stringToken.value
        self.typograph = PurchaseTypograph(rawValue: stringToken.style) ?? .body1
    }
}
```

### 3. Typograph Enum with Font/Color Mapping
**File**: `PurchaseTypograph.swift` (Lines 3-54)
```swift
public enum PurchaseTypograph: String {
    case header1, header2, header3, header4, header5
    case body1, body2, body3
    case note, notePositive, noteNegative
    
    var color: Color { /* Maps to Color enum */ }
    var font: any FontStyle { /* Maps to Font enum */ }
}
```

### 4. setTypograph Methods

**A. String version** (for rawValue):
**File**: `MockMissingTypes.swift` (Lines 114-134)
```swift
extension Text {
    func setTypograph(_ typograph: String) {
        if let purchaseTypograph = PurchaseTypograph(rawValue: typograph) {
            setTypograph(purchaseTypograph)
        }
    }
}
```

**B. PurchaseTypograph version** (applies styling):
**File**: `PurchaseTypograph.swift` (Lines 72-76)
```swift
extension Text {
    public func setTypograph(_ typograph: PurchaseTypograph) {
        font(typograph.font)
        foreground(color: typograph.color)
    }
}
```

### 5. Font & Color Application
**File**: `MockUIComponents.swift` (Lines 109-124)
```swift
class Text: UILabel {
    func font(_ fontStyle: FontStyle) -> Self {
        self.font = fontStyle.uiFont
        return self
    }
    
    func foreground(color: Color) -> Self {
        self.textColor = color.uiColor
        return self
    }
}
```

---

## Usage Examples

### Example 1: Welcome Screen Title

```swift
// 1. API returns
StringToken(value: "Bem-vindo", style: "header1")

// 2. Presenter converts
let title = StringWithTypograph(stringToken: model.name)
// → StringWithTypograph(value: "Bem-vindo", typograph: .header1)

// 3. View applies
titleText.value = dto.title.value  // "Bem-vindo"
titleText.setTypograph(dto.title.typograph)  // .header1

// 4. setTypograph applies
font(.large)  // 28pt bold
foreground(color: .primary900)  // Dark gray

// 5. UILabel displays
// "Bem-vindo" in 28pt bold, dark gray color
```

### Example 2: List Cell Label (using rawValue)

```swift
// In PurchaseListTableViewCell.swift (Line 74)
titleLabel.setTypograph(titleTypograph)  // String "header4"

// Goes to MockMissingTypes.setTypograph(String)
// Converts "header4" → PurchaseTypograph.header4
// Then calls setTypograph(PurchaseTypograph.header4)
// Applies font and color
```

---

## Summary

The mapping happens in **multiple stages**:

1. **StringToken** (from API) → **StringWithTypograph** (in Presenter)
   - Location: `PurchaseTypograph.swift` line 66-69
   - Converts: `String` style → `PurchaseTypograph` enum

2. **StringWithTypograph** → **Styled UILabel** (in View)
   - Location: View files call `setTypograph()`
   - Two paths:
     - Direct: `setTypograph(PurchaseTypograph)` → `PurchaseTypograph.swift` line 73
     - Via String: `setTypograph(String)` → `MockMissingTypes.swift` line 115 → then method above

3. **PurchaseTypograph enum** → **Font & Color**
   - Location: `PurchaseTypograph.swift` lines 16-54
   - Maps enum cases to `Font` and `Color` values

4. **Font & Color** → **UILabel properties**
   - Location: `MockUIComponents.swift` lines 109-124
   - Applies `UIFont` and `UIColor` to the label

**The key conversion point is `PurchaseTypograph.swift` line 66-69**, where `StringToken` becomes `StringWithTypograph` with a `PurchaseTypograph` enum instead of a string.


