import Foundation

/// Manager with all the necessary methods to interact with the keychain
public class KeychainManager {
    
    private var attributes: ItemAttributes?
    
    public class var standard: KeychainManager {
        return KeychainManager()
    }
    
    public init(attributes: ItemAttributes? = nil) {
        self.attributes = attributes
    }
    
    /// Save any Encodable data into the keychain
    ///
    /// ``` swift
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
    public func saveItem<T: Encodable>(_ item: T, itemClass: ItemClass, key: String) throws {
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
    /// ```swift
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
    public func retrieveItem<T: Decodable>(ofClass itemClass: ItemClass, key: String) throws -> T {
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
    /// ```swift
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
    public func updateItem<T: Encodable>(with item: T, ofClass itemClass: ItemClass, key: String) throws {
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
    /// ```swift
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
    public func deleteItem(ofClass itemClass: ItemClass, key: String) throws {
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

// MARK: - Utils

private extension KeychainManager {
    
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
