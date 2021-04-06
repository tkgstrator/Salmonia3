//
//  KeychainStorage.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/06.
//

import Foundation
import SwiftUI
import KeychainAccess

@propertyWrapper
struct KeyStorage<T: Codable>: DynamicProperty {
    typealias Value = T
    let key: String
    @State private var value: Value

    init(wrappedValue: Value, _ key: String) {
        self.key = key
        var initialValue = wrappedValue
        do {
            try Keychain().get(key) { attributes in
                if let attributes = attributes, let data = attributes.data {
                    do {
                        initialValue = try JSONDecoder().decode(Value.self, from: data)
                    } catch {
                        fatalError("\(error)")
                    }
                }
            }
        } catch {
            fatalError("\(error)")
        }
        self._value = State<Value>(initialValue: initialValue)
    }

    var wrappedValue: Value {
        get { value }

        nonmutating set {
            value = newValue
            do {
                try Keychain().set(try JSONEncoder().encode(value), key: key)
            } catch {
                fatalError("\(error)")
            }
        }
    }

    var projectedValue: Binding<Value> {
        Binding(get: { wrappedValue }, set: { wrappedValue = $0 })
    }
}
