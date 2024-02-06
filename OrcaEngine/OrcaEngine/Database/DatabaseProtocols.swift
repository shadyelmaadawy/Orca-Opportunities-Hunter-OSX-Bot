//
//  DatabaseProtocols.swift
//  OrcaEngine
//
//  Created by Shady El-Maadawy on 30/01/2024.
//

import Foundation

internal protocol DatabaseProxyProtocol: AnyObject {
    func saveKeywords(values: [OrcaKeyword]) throws
    func extractKeywords(whereSuitability: Bool) throws -> [OrcaModel]
}

