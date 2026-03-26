import Apollo

public enum PurchaseTypograph: String, Equatable {
    case header1
    case header2
    case header3
    case header4
    case header5
    case body1
    case body2
    case body3
    case note
    case notePositive
    case noteNegative

    var color: Color {
        switch self {
        case .header1, .header2, .header3:
            return .primary900
        case .header4:
            return .primary800
        case .header5, .body1:
            return .grayScale800
        case .body2:
            return .grayScale900
        case .body3:
            return .primary500
        case .note:
            return .grayScale900
        case .notePositive:
            return .feedbackSuccess500
        case .noteNegative:
            return .feedbackWarning500
        }
    }

    var font: any FontStyle {
        switch self {
        case .header1:
            return Font.large
        case .header2, .header5:
            return Font.medium
        case .header3, .header4:
            return Font.small
        case .body1:
            return Font.body
        case .body2, .body3:
            return Font.body.highlighted
        case .note:
            return Font.note
        case .notePositive, .noteNegative:
            return Font.note.highlighted
        }
    }
}

public struct StringWithTypograph: Equatable {
    var value: String
    var typograph: PurchaseTypograph

    public init(value: String, typograph: String) {
        self.value = value
        self.typograph = PurchaseTypograph(rawValue: typograph) ?? .body1
    }

    public init(stringToken: StringToken) {
        self.value = stringToken.value
        self.typograph = PurchaseTypograph(rawValue: stringToken.style) ?? .body1
    }
}

extension Text {
    public func setTypograph(_ typograph: PurchaseTypograph) {
        font(typograph.font)
        foreground(color: typograph.color)
    }
}
