import Foundation
import UIKit

// MARK: - StringToken (Backend Template Architecture)
public struct StringToken: Decodable, Equatable {
    let value: String
    let style: String
    
    public init(value: String, style: String) {
        self.value = value
        self.style = style
    }
}

// MARK: - StringWithTypograph (Backend Template Architecture)
public struct StringWithTypograph: Equatable, Decodable {
    var value: String
    var typograph: PurchaseTypograph
    
    public init(stringToken: StringToken) {
        self.value = stringToken.value
        self.typograph = PurchaseTypograph(rawValue: stringToken.style) ?? .body1
    }
    
    public init(value: String, typograph: String) {
        self.value = value
        self.typograph = PurchaseTypograph(rawValue: typograph) ?? .body1
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringToken = try container.decode(StringToken.self)
        self.value = stringToken.value
        self.typograph = PurchaseTypograph(rawValue: stringToken.style) ?? .body1
    }
}

// MARK: - PurchaseTypograph (Backend Template Architecture)
public enum PurchaseTypograph: String, Equatable {
    case title1 = "title1"
    case title2 = "title2"
    case title3 = "title3"
    case headline = "headline"
    case body1 = "body1"
    case body2 = "body2"
    case caption = "caption"
    case overline = "overline"
    
    var font: UIFont {
        switch self {
        case .title1: return UIFont.systemFont(ofSize: 28, weight: .bold)
        case .title2: return UIFont.systemFont(ofSize: 22, weight: .bold)
        case .title3: return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .headline: return UIFont.systemFont(ofSize: 17, weight: .semibold)
        case .body1: return UIFont.systemFont(ofSize: 17, weight: .regular)
        case .body2: return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .caption: return UIFont.systemFont(ofSize: 12, weight: .regular)
        case .overline: return UIFont.systemFont(ofSize: 10, weight: .medium)
        }
    }
    
    var color: UIColor {
        switch self {
        case .title1, .title2, .title3, .headline:
            return .label
        case .body1, .body2:
            return .secondaryLabel
        case .caption, .overline:
            return .tertiaryLabel
        }
    }
}

