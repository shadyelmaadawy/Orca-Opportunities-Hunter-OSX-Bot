//
//  SQLiteDatabaseProxy.swift
//  OrcaEngine
//
//  Created by Shady El-Maadawy on 30/01/2024.
//

import SQLite
import Foundation

internal final class SQLiteDatabaseProxy: DatabaseProxyProtocol {
    
    // MARK: - Properties
    
    private let databaseConnection: Connection
    private let keywordsTable: Table = Table.init("KeywordsTable")
    private let keywordValueColumn = Expression<String>.init("keywordValue")
    private let isSuitableColumn = Expression<Bool>.init("isSuitable")
    
    // MARK: - Initialization
    
    init(reconfigureDatabase: Bool) throws {
        self.databaseConnection = try Connection.init(URL.databaseURL)
        try self.configure()
    }
    
}


// MARK: - Configure

internal extension SQLiteDatabaseProxy {
    
    func configure() throws {
        
        try databaseConnection.run(keywordsTable.create(ifNotExists: true) { tableBuilder in
            tableBuilder.column(keywordValueColumn)
            tableBuilder.column(isSuitableColumn)
        })

  }
    
}

// MARK: - Operations

internal extension SQLiteDatabaseProxy {
    
    func saveKeywords(values: [OrcaKeyword]) throws {
        
        try values.forEach({
            
            try databaseConnection.run(keywordsTable.insert($0))
            
        })
        

    }
    
    func extractKeywords(whereSuitability: Bool) throws -> [OrcaModel] {
        
        let sqlQuery = """
            SELECT DISTINCT keywordValue FROM KeywordsTable
            WHERE keywordValue NOT IN (
               SELECT a.keywordValue FROM KeywordsTable AS a
               LEFT JOIN KeywordsTable AS b
               ON a.keywordValue = b.keywordValue
               WHERE b.isSuitable = \(whereSuitability == true ? 0 : 1)
            );
            """
        
        return try databaseConnection.prepare(sqlQuery).map({
            return OrcaModel.init(keywordValue: $0[0] as! String, isSuitable: whereSuitability)
        })
    }

}
