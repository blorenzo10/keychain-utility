import Foundation

@propertyWrapper
public struct KeychainStorage<T: Codable> {
    let key: String
    let itemClass: ItemClass
    let keychain: KeychainManager
    
    private var currentValue: T?
    
    public var wrappedValue: T? {
        get {
            return getItem()
        }
        
        set {
            if let newValue {
                getItem() != nil
                    ? updateItem(newValue)
                    : saveItem(newValue)
            } else {
                deleteItem()
            }
        }
    }
    
    public init(key: String, itemClass: ItemClass, keychain: KeychainManager = .standard) {
        self.key = key
        self.itemClass = itemClass
        self.keychain = keychain
    }
}

// MARK: - Helpers
private extension KeychainStorage {
    
    func getItem() -> T? {
        do {
            return try keychain.retrieveItem(ofClass: itemClass, key: key)
        } catch {
            handleError(error)
        }
        return nil
    }
    
    func saveItem(_ item: T) {
        do {
            try keychain.saveItem(item, itemClass: itemClass, key: key)
        } catch {
            handleError(error)
        }
    }
    
    func updateItem(_ item: T) {
        do {
            try keychain.updateItem(with: item, ofClass: itemClass, key: key)
        } catch {
            handleError(error)
        }
    }
    
    func deleteItem() {
        do {
            try keychain.deleteItem(ofClass: itemClass, key: key)
        } catch {
            handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        print(error)
    }
}
