# Overview

Keychain Utility is a wrapper to help you interact with the Keychain APIs in an easier way

# Usage
Add `@KeychainStorage` annotation in the properties you want to store into the keychain (or read from it). Provide a `Key` and an `ItemType` (you can check the list [here](https://blorenzo10.github.io/keychain-utility/documentation/keychainutility/itemclass))

```swift
@KeychainStorage(key: "API-Token", itemClass: .generic)
var token: String?

// It will print the current value
print(token)

// Update item
token = "c0c61d55558b0c8dac82a16c04981eea7c99e37d714367e575028221028b0d4cff122d6a7556fc0ab1c66d1d4b05b378"
 
// Delete item
token = nil 
```

# Documentation

Check [Keychain Utility Documentation Page](https://blorenzo10.github.io/keychain-utility/documentation/keychainutility/) for more info.

# Installetion
## SwiftPM

In Xcode go to File > Add Packages. In the Search or Enter Package URL search box enter this URL: https://github.com/blorenzo10/keychain-utility

# Contribution

If you want to report a bug or need a new feature, open an issue from the issues tab
