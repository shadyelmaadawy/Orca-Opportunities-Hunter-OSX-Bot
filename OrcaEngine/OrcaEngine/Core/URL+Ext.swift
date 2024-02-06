//
//  URL+Ext.swift
//  OrcaEngine
//
//  Created by Shady El-Maadawy on 31/12/2023.
//

import Foundation

public extension URL {
    
    static var defaultDirectoryPath: URL {
        return URL.desktopDirectory
    }
    
    /// Default Model Path
    static var nlModelURL: URL {
        let orcaModelPath = defaultDirectoryPath.appendingPathComponent("Orca.mlmodel")
        return orcaModelPath
    }
    
    
    /// Default Database Path
    static var databaseURL: String {
        let orcaModelPath = defaultDirectoryPath.appendingPathComponent("Orca.sqlite3")
        return orcaModelPath.absoluteString
    }

}
