//
//  OrcaModel.swift
//  Orca Engine
//
//  Created by Shady El-Maadawy on 31/12/2023.
//

import Foundation

public final class OrcaModel: Codable {
    
    // MARK: - Properties
    
    public let keywordValue: String
    public let isSuitable: String
    
    // MARK: - Initialization
    
    public init(keywordValue: String, isSuitable: Bool) {

        self.keywordValue = keywordValue

        if(isSuitable) {
            self.isSuitable = "True"
        } else {
            self.isSuitable = "False"
        }
        
    }
    
}

