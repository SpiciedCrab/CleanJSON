// 
//  _CleanJSONKeyedDecodingContainer.swift
//  CleanJSON
//
//  Created by Pircate(gao497868860@gmail.com) on 2018/10/10
//  Copyright © 2018 Pircate. All rights reserved.
//

import Foundation

struct _CleanJSONKeyedDecodingContainer<K : CodingKey>: KeyedDecodingContainerProtocol {
    
    typealias Key = K
    
    // MARK: Properties
    
    /// A reference to the decoder we're reading from.
    private let decoder: _CleanJSONDecoder
    
    /// A reference to the container we're reading from.
    private let container: [String : Any]
    
    /// The path of coding keys taken to get to this point in decoding.
    private(set) public var codingPath: [CodingKey]
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: _CleanJSONDecoder, wrapping container: [String : Any]) {
        self.decoder = decoder
        switch decoder.options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.container = container
        case .convertFromSnakeCase:
            // Convert the snake case keys in the container to camel case.
            // If we hit a duplicate key after conversion, then we'll use the first one we saw. Effectively an undefined behavior with JSON dictionaries.
            self.container = Dictionary(container.map {
                dict in (CleanJSONDecoder.KeyDecodingStrategy._convertFromSnakeCase(dict.key), dict.value)
            }, uniquingKeysWith: { (first, _) in first })
        case .custom(let converter):
            self.container = Dictionary(container.map {
                key, value in (converter(decoder.codingPath + [_CleanJSONKey(stringValue: key, intValue: nil)]).stringValue, value)
            }, uniquingKeysWith: { (first, _) in first })
        }
        self.codingPath = decoder.codingPath
    }
    
    // MARK: - KeyedDecodingContainerProtocol Methods
    
    public var allKeys: [Key] {
        return self.container.keys.compactMap { Key(stringValue: $0) }
    }
    
    public func contains(_ key: Key) -> Bool {
        return self.container[key.stringValue] != nil
    }
    
    private func _errorDescription(of key: CodingKey) -> String {
//        switch decoder.options.keyDecodingStrategy {
//        case .convertFromSnakeCase:
//            // In this case we can attempt to recover the original value by reversing the transform
//            let original = key.stringValue
//            let converted = JSONEncoder.KeyEncodingStrategy._convertToSnakeCase(original)
//            if converted == original {
//                return "\(key) (\"\(original)\")"
//            } else {
//                return "\(key) (\"\(original)\"), converted to \(converted)"
//            }
//        default:
            // Otherwise, just report the converted string
            return "\(key) (\"\(key.stringValue)\")"
//        }
    }
    
    public func decodeNil(forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
        }
        
        return entry is NSNull
    }
    
    public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Bool.defaultValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Bool.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Bool.defaultValue
            case .custom(let adaptor):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adaptor.decodeBool(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int.defaultValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Int.defaultValue
            case .custom(let adaptor):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adaptor.decodeInt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard let entry = self.container[key.stringValue] else {
            return 0
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int8.self) else {
            return 0
        }
        
        return value
    }
    
    public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard let entry = self.container[key.stringValue] else {
            return 0
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int16.self) else {
            return 0
        }
        
        return value
    }
    
    public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard let entry = self.container[key.stringValue] else {
            return 0
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int32.self) else {
            return 0
        }
        
        return value
    }
    
    public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard let entry = self.container[key.stringValue] else {
            return 0
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Int64.self) else {
            return 0
        }
        
        return value
    }
    
    public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt.defaultValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return UInt.defaultValue
            case .custom(let adaptor):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adaptor.decodeUInt(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard let entry = self.container[key.stringValue] else {
            return 0
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt8.self) else {
            return 0
        }
        
        return value
    }
    
    public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard let entry = self.container[key.stringValue] else {
            return 0
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt16.self) else {
            return 0
        }
        
        return value
    }
    
    public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard let entry = self.container[key.stringValue] else {
            return 0
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt32.self) else {
            return 0
        }
        
        return value
    }
    
    public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard let entry = self.container[key.stringValue] else {
            return 0
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: UInt64.self) else {
            return 0
        }
        
        return value
    }
    
    public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Float.defaultValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Float.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Float.defaultValue
            case .custom(let adaptor):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adaptor.decodeFloat(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Double.defaultValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: Double.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return Double.defaultValue
            case .custom(let adaptor):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adaptor.decodeDouble(decoder)
            }
        }
        
        return value
    }
    
    public func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard let entry = self.container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return String.defaultValue
            }
        }
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = try self.decoder.unbox(entry, as: String.self) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return String.defaultValue
            case .custom(let adaptor):
                decoder.storage.push(container: entry)
                defer { decoder.storage.popContainer() }
                return try adaptor.decodeString(decoder)
            }
        }
        
        return value
    }
    
    private func decodeUseDefaultValue<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        if let objectValue = try? CleanJSONDecoder().decode(type, from: "{}".data(using: .utf8)!) {
            return objectValue
        } else if let arrayValue = try? CleanJSONDecoder().decode(type, from: "[]".data(using: .utf8)!) {
            return arrayValue
        } else if let stringValue = try decode(String.self, forKey: key) as? T {
            return stringValue
        } else if let boolValue = try decode(Bool.self, forKey: key) as? T {
            return boolValue
        } else if let intValue = try decode(Int.self, forKey: key) as? T {
            return intValue
        } else if let uintValue = try decode(UInt.self, forKey: key) as? T {
            return uintValue
        } else if let doubleValue = try decode(Double.self, forKey: key) as? T {
            return doubleValue
        } else if let floatValue = try decode(Float.self, forKey: key) as? T {
            return floatValue
        }
        let context = DecodingError.Context(codingPath: [key], debugDescription: "Key: <\(key.stringValue)> cannot be decoded")
        throw DecodingError.dataCorrupted(context)
    }
    
    public func decode<T : Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        guard let entry = container[key.stringValue] else {
            switch decoder.options.keyNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.keyNotFound(key, codingPath: decoder.codingPath)
            case .useDefaultValue:
                return try decodeUseDefaultValue(type, forKey: key)
            }
        }
        
        decoder.codingPath.append(key)
        defer { decoder.codingPath.removeLast() }
        
        guard let value = try decoder.unbox(entry, as: type) else {
            switch decoder.options.valueNotFoundDecodingStrategy {
            case .throw:
                throw DecodingError.Keyed.valueNotFound(type, codingPath: decoder.codingPath)
            case .useDefaultValue, .custom:
                return try decodeUseDefaultValue(type, forKey: key)
            }
        }
        
        return value
    }
    
    public func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            switch decoder.options.nestedContainerDecodingStrategy.keyNotFound {
            case .throw:
                throw DecodingError.Nested.keyNotFound(key, codingPath: codingPath)
            case .useEmptyContainer:
                return nestedContainer()
            }
        }
        
        guard let dictionary = value as? [String : Any] else {
            switch decoder.options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: self.codingPath,
                    expectation: [String : Any].self,
                    reality: value)
            case .useEmptyContainer:
                return nestedContainer()
            }
        }
        
        return nestedContainer(wrapping: dictionary)
    }
    
    private func nestedContainer<NestedKey>(wrapping dictionary: [String: Any] = [:])
        -> KeyedDecodingContainer<NestedKey> {
        let container = _CleanJSONKeyedDecodingContainer<NestedKey>(
            referencing: decoder,
            wrapping: dictionary)
        return KeyedDecodingContainer(container)
    }
    
    public func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        guard let value = self.container[key.stringValue] else {
            switch decoder.options.nestedContainerDecodingStrategy.keyNotFound {
            case .throw:
                throw DecodingError.Nested.keyNotFound(key, codingPath: codingPath, isUnkeyed: true)
            case .useEmptyContainer:
                return _CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
            }
        }
        
        guard let array = value as? [Any] else {
            switch decoder.options.nestedContainerDecodingStrategy.typeMismatch {
            case .throw:
                throw DecodingError._typeMismatch(
                    at: self.codingPath,
                    expectation: [Any].self, reality: value)
            case .useEmptyContainer:
                return _CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: [])
            }
        }
        
        return _CleanJSONUnkeyedDecodingContainer(referencing: self.decoder, wrapping: array)
    }
    
    private func _superDecoder(forKey key: CodingKey) throws -> Decoder {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        let value: Any = self.container[key.stringValue] ?? NSNull()
        return _CleanJSONDecoder(referencing: value, at: self.decoder.codingPath, options: self.decoder.options)
    }
    
    public func superDecoder() throws -> Decoder {
        return try _superDecoder(forKey: _CleanJSONKey.super)
    }
    
    public func superDecoder(forKey key: Key) throws -> Decoder {
        return try _superDecoder(forKey: key)
    }
}

extension CleanJSONDecoder.KeyDecodingStrategy {
    
    fileprivate static func _convertFromSnakeCase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }
        
        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.index(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }
        
        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }
        
        let keyRange = firstNonUnderscore...lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex
        
        var components = stringKey[keyRange].split(separator: "_")
        let joinedString : String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }
        
        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result : String
        if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
            result = joinedString
        } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
            // Both leading and trailing underscores
            result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
        } else if (!leadingUnderscoreRange.isEmpty) {
            // Just leading
            result = String(stringKey[leadingUnderscoreRange]) + joinedString
        } else {
            // Just trailing
            result = joinedString + String(stringKey[trailingUnderscoreRange])
        }
        return result
    }
}
