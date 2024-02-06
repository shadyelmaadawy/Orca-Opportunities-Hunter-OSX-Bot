//
//  JsonDecoderEngine.swift
//  Utilities
//
//  Created by Shady El-Maadawy on 30/01/2024.
//

import Foundation

public struct JsonDecoderEngine {

    // MARK: - Properties
    
    private let decoder: JSONDecoder

    // MARK: - Initialization
    
    public init(_ jsonDecoder: JSONDecoder = .init()) {
        self.decoder = jsonDecoder
    }

}

// MARK: - Operations

public extension JsonDecoderEngine {
    
    func parse<T: Codable>(from dataBuffer: String, as jsonObject: T.Type) throws -> T {
        return try decoder.decode(jsonObject, from: Data.init(dataBuffer.utf8))
    }
    
}
