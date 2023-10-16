
import Foundation
import XCTest
@testable import KeychainUtility

final class PropertyWrapperTests: XCTestCase {
    
    @KeychainStorage(key: "API-Token", itemClass: .generic)
    var token: String?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        token = nil
    }
    
    func testSaveItem() {
        token = "c0c61d55558b0c8dac82a16c04981eea7c99e37d714367e575028221028b0d4cff122d6a7556fc0ab1c66d1d4b05b378"
        let keychainToken: String? = try? KeychainManager.standard.retrieveItem(ofClass: .generic, key: "API-Token")
        XCTAssertEqual(token, keychainToken)
    }
    
    func testUpdateItem() {
        token = "c0c61d55558b0c8dac82a16c04981eea7c99e37d714367e575028221028b0d4cff122d6a7556fc0ab1c66d1d4b05b378"
        var keychainToken: String? = try? KeychainManager.standard.retrieveItem(ofClass: .generic, key: "API-Token")
        XCTAssertEqual(token, keychainToken)
        
        token = "b7bb1d55558b0c8dac82a16c04981eea7c99e37d714367e575028221028b0d4cff122d6a7556fc0ab1c66d1d4b05b378"
        XCTAssertNotEqual(token, keychainToken)
        
        keychainToken = try? KeychainManager.standard.retrieveItem(ofClass: .generic, key: "API-Token")
        XCTAssertEqual(token, keychainToken)
    }
    
    func testRemoveItem() {
        token = "c0c61d55558b0c8dac82a16c04981eea7c99e37d714367e575028221028b0d4cff122d6a7556fc0ab1c66d1d4b05b378"
        var keychainToken: String? = try? KeychainManager.standard.retrieveItem(ofClass: .generic, key: "API-Token")
        XCTAssertEqual(token, keychainToken)
        
        token = nil
        keychainToken = try? KeychainManager.standard.retrieveItem(ofClass: .generic, key: "API-Token")
        XCTAssertNil(token)
    }
}
