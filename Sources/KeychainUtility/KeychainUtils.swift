//
//  File.swift
//  
//
//  Created by Bruno Lorenzo on 5/10/23.
//

import Foundation

public typealias KeychainDictionary = [String : Any]
public typealias ItemAttributes = [CFString : Any]

extension KeychainDictionary {
    mutating func addAttributes(_ attributes: ItemAttributes) {
        for(key, value) in attributes {
            self[key as String] = value
        }
    }
}
