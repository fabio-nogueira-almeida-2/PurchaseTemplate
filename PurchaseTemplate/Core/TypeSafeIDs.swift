//
//  TypeSafeIDs.swift
//  PurchaseTemplate
//
//  Type-safe identifiers to replace String-based IDs
//

import Foundation

// MARK: - Product Type ID
enum ProductTypeID: String, Codable, Hashable {
    case investmentFunds = "1"
    case royaltiesInvestment = "2"
    
    var displayName: String {
        switch self {
        case .investmentFunds:
            return "Investment Funds"
        case .royaltiesInvestment:
            return "Royalties Investment"
        }
    }
    
    init?(string: String) {
        self.init(rawValue: string)
    }
}

// MARK: - Product ID
struct ProductID: Codable, Hashable, ExpressibleByStringLiteral {
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    init(stringLiteral value: String) {
        self.value = value
    }
    
    var intValue: Int? {
        return Int(value)
    }
}

// MARK: - Offer ID
struct OfferID: Codable, Hashable, ExpressibleByStringLiteral {
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    init(stringLiteral value: String) {
        self.value = value
    }
    
    var intValue: Int? {
        return Int(value)
    }
}

// MARK: - Extensions for backward compatibility
extension ProductID: CustomStringConvertible {
    var description: String { value }
}

extension OfferID: CustomStringConvertible {
    var description: String { value }
}

extension ProductTypeID: CustomStringConvertible {
    var description: String { rawValue }
}


