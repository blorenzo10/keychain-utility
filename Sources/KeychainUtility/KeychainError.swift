import Foundation

public enum KeychainError: Error {
    case invalidData
    case itemNotFound
    case duplicateItem
    case incorrectAttributeForClass
    case unexpected(OSStatus)
    
    var description: String {
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
