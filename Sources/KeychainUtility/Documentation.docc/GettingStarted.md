# GettingStarted

Save sensitive information into the keychain with KeychainUtility wrapper

## Overview

The goal of `KeychainUtility` is to make keychain interactions smoothly

### Save an item
Use ``KeychainManager/saveItem(_:itemClass:key:attributes:)`` to store an item into the keychain.  

You might choose between 5 differents item classes:
- Generic Password: Indicates a generic password item.
- Internet Password: Indicates an internet password.
- Certificate: Indicates a certificate item.
- Class Key: Indicates a cryptographic item.
- Class Identity: Indicates an identity item.

Depending on the type of item that we’ll be working with, the attributes that we’ll have available for usage. You can check the full list [here](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values).

```swift
let apiToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnb2Fsc2J1ZGR5IiwiZXhwIjo2NDA5MjIxMTIwMH0.JoDuSMARI2Ihh8fisiUxfQiP8AE_WFz9Hcogkk8QMcQ"
do {
    let apiTokenAttributes: KeychainManager.ItemAttributes = [kSecAttrLabel: "ApiToken"]
    try KeychainManager.shared.saveItem(apiToken, itemClass: .generic, key: "ApiToken", attributes: apiTokenAttributes)
} catch let keychainError as KeychainManager.KeychainError {
    print(keychainError.description)
} catch {
    print(error)
}
```

### Update an item
Use ``KeychainManager/updateItem(with:ofClass:key:attributes:)`` to update an item that was already saved into the keychain

```swift
do {
    let apiTokenAttributes: KeychainManager.ItemAttributes = [kSecAttrLabel: "ApiToken"]
    try KeychainManager.shared.updateItem(with: "new-token-value", ofClass: .generic, key: "ApiToken", attributes: apiTokenAttributes)
} catch let keychainError as KeychainManager.KeychainError {
    print(keychainError.description)
} catch {
    print(error)
}
```

### Retreive an item
Use ``KeychainManager/retrieveItem(ofClass:key:attributes:)`` to get an item by its key.

```swift
do {
    let apiTokenAttributes: KeychainManager.ItemAttributes = [kSecAttrLabel: "ApiToken"]
    let token: String = try KeychainManager.shared.retrieveItem(ofClass: .generic, key: "ApiToken", attributes: apiTokenAttributes)
} catch let keychainError as KeychainManager.KeychainError {
    print(keychainError.description)
} catch {
    print(error)
}
```

### Delete an item
Use ``KeychainManager/deleteItem(ofClass:key:attributes:)`` to remove an item from the keychain.

```swift
do {
    let apiTokenAttributes: KeychainManager.ItemAttributes = [kSecAttrLabel: "ApiToken"]
    try KeychainManager.shared.deleteImte(ofClass: .generic, key: "ApiToken", attributes: apiTokenAttributes)
} catch let keychainError as KeychainManager.KeychainError {
    print(keychainError.description)
} catch {
    print(error)
}
```
