import Foundation

/// List of errors handled by KeychainUtility
public enum KeychainError: Error {
    /// The data that you try to store is not valid
    case invalidData
    /// The item you try to retrieve was not found
    case itemNotFound
    /// There's an item with the same key already in the keychain
    case duplicateItem
    /// The attributes are not correct for the class
    case incorrectAttributeForClass
    /// Unhandled error
    case unexpected(OSStatus)
    
    /// User-friendly error description
    public var description: String {
        switch self {
        case .invalidData:
            return "Invalid data"
        case .itemNotFound:
            return "Item not found"
        case .duplicateItem:
            return "Duplicate Item"
        case .incorrectAttributeForClass:
            return "Incorrect Attribute for Class"
        case .unexpected(let oSStatus):
            return "Unexpected error - \(oSStatus)"
        }
    }
}
