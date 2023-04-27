import Foundation

public enum ItemClass: RawRepresentable, CaseIterable {
    public typealias RawValue = CFString
    
    case generic
    case password
    case certificate
    case cryptography
    case identity
    
    public init?(rawValue: CFString) {
        switch rawValue {
        case kSecClassGenericPassword:
            self = .generic
        case kSecClassInternetPassword:
            self = .password
        case kSecClassCertificate:
            self = .certificate
        case kSecClassKey:
            self = .cryptography
        case kSecClassIdentity:
            self = .identity
        default:
            return nil
        }
    }
    
    public var rawValue: CFString {
        switch self {
        case .generic:
            return kSecClassGenericPassword
        case .password:
            return kSecClassInternetPassword
        case .certificate:
            return kSecClassCertificate
        case .cryptography:
            return kSecClassKey
        case .identity:
            return kSecClassIdentity
        }
    }
    
    public var name: String {
        switch self {
        case .generic:
            return "Generic"
        case .password:
            return "Password"
        case .certificate:
            return "Certificate"
        case .cryptography:
            return "Cryptography"
        case .identity:
            return "Identity"
        }
    }
}
