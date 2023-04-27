import Foundation

public class KeychainManager {
    
    public static let shared = KeychainManager()
    
    public typealias KeychainDictionary = [String : Any]
    public typealias ItemAttributes = [CFString : Any]
    
    /// Save any Encodable data into the keychain
    ///
    /// ```
    /// do {
    ///    let apiTokenAttributes: KeychainManager.ItemAttributes = [
    ///         kSecAttrLabel: "ApiToken"
    ///    ]
    ///    try KeychainManager.shared.saveItem(apiToken, itemClass: .generic, attributes: apiTokenAttributes)
    ///    print("Api Token saved!")
    /// } catch let keychainError as KeychainManager.KeychainError {
    ///     print(keychainError.localizedDescription)
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    ///
    /// - Parameter item: The item to be saved
    /// - Parameter itemClass: The item class
    /// - Parameter key: Key to identifiy the item
    /// - Parameter attributes: Optional dictionary with attributes to narrow the search
    public func saveItem<T: Encodable>(_ item: T, itemClass: ItemClass, key: String, attributes: ItemAttributes? = nil) throws {
        
        let itemData = try JSONEncoder().encode(item)
        var query: KeychainDictionary = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject,
            kSecValueData as String: itemData as AnyObject
        ]
        
        if let itemAttributes = attributes {
            query.addAttributes(itemAttributes)
        }
        
        let result = SecItemAdd(query as CFDictionary, nil)
        if result != errSecSuccess {
            throw convertError(result)
        }
    }
    
    /// Retrieve a decodable item from the keychain
    ///
    /// ```
    /// do {
    ///    let apiTokenAttributes: KeychainManager.ItemAttributes = [
    ///         kSecAttrLabel: "ApiToken"
    ///    ]
    ///    let token: String = try KeychainManager.shared.retrieveItem(ofClass: .generic, attributes: apiTokenAttributes)
    /// } catch let keychainError as KeychainManager.KeychainError {
    ///     print(keychainError.localizedDescription)
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    ///
    /// - Parameter itemClass: The item class
    /// - Parameter key: Key to identifiy the item
    /// - Parameter attributes: Optional dictionary with attributes to narrow the search
    /// - Returns: An instance of type `T`
    public func retrieveItem<T: Decodable>(ofClass itemClass: ItemClass, key: String, attributes: ItemAttributes? = nil) throws -> T {
        var query: KeychainDictionary = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        if let itemAttributes = attributes {
            query.addAttributes(itemAttributes)
        }
        
        var item: CFTypeRef?
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        if result != errSecSuccess {
            throw convertError(result)
        }
        
        guard let keychainItem = item as? [String : Any], let data = keychainItem[kSecValueData as String] as? Data else {
            throw KeychainError.invalidData
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// Update an encodable item from the keychain
    ///
    /// ```
    /// do {
    ///    let apiTokenAttributes: KeychainManager.ItemAttributes = [
    ///         kSecAttrLabel: "ApiToken"
    ///    ]
    ///    let token: String = try KeychainManager.shared.retrieveItem(ofClass: .generic, attributes: apiTokenAttributes)
    /// } catch let keychainError as KeychainManager.KeychainError {
    ///     print(keychainError.localizedDescription)
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    ///
    /// - Parameter item: Item to update
    /// - Parameter itemClass: The item class
    /// - Parameter key: Key to identifiy the item
    /// - Parameter attributes: Optional dictionary with attributes to narrow the search
    public func updateItem<T: Encodable>(with item: T, ofClass itemClass: ItemClass, key: String, attributes: ItemAttributes? = nil) throws {
        var query: KeychainDictionary = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject,
        ]
        
        if let itemAttributes = attributes {
            query.addAttributes(itemAttributes)
        }
        
        let itemData = try JSONEncoder().encode(item)
        
        let attributesToUpdate: KeychainDictionary = [
            kSecValueData as String: itemData as AnyObject
        ]
        
        let result = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        if result != errSecSuccess {
            throw convertError(result)
        }
    }
    
    /// Delete an item from the keychain
    ///
    /// ```
    /// do {
    ///    let apiTokenAttributes: KeychainManager.ItemAttributes = [
    ///         kSecAttrLabel: "ApiToken"
    ///    ]
    ///    try KeychainManager.shared.deleteImte(ofClass: .generic, attributes: apiTokenAttributes)
    /// } catch let keychainError as KeychainManager.KeychainError {
    ///     print(keychainError.localizedDescription)
    /// } catch {
    ///     print(error)
    /// }
    /// ```
    ///
    /// - Parameter itemClass: The item class
    /// - Parameter key: Key to identifiy the item
    /// - Parameter attributes: Optional dictionary with attributes to narrow the search
    public func deleteItem(ofClass itemClass: ItemClass, key: String, attributes: ItemAttributes? = nil) throws {
        var query: KeychainDictionary = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject
        ]
        
        if let itemAttributes = attributes {
            query.addAttributes(itemAttributes)
        }
        
        let result = SecItemDelete(query as CFDictionary)
        if result != errSecSuccess {
            throw convertError(result)
        }
    }
}

// MARK: - ItemClass

public extension KeychainManager {
    enum ItemClass: RawRepresentable {
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
    }
}

// MARK: - Errors

public extension KeychainManager {
    enum KeychainError: Error {
        case invalidData
        case itemNotFound
        case duplicateItem
        case incorrectAttributeForClass
        case unexpected(OSStatus)
        
        var localizedDescription: String {
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
    
    private func convertError(_ error: OSStatus) -> KeychainError {
        switch error {
        case errSecItemNotFound:
            return .itemNotFound
        case errSecDataTooLarge:
            return .invalidData
        case errSecDuplicateItem:
            return .duplicateItem
        default:
            return .unexpected(error)
        }
    }
}

// MARK: - Dictionary

extension KeychainManager.KeychainDictionary {
    mutating func addAttributes(_ attributes: KeychainManager.ItemAttributes) {
        for(key, value) in attributes {
            self[key as String] = value
        }
    }
}
