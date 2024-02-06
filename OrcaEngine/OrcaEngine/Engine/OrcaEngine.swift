//
//  OrcaEngine.swift
//  OrcaEngine
//
//  Created by Shady El-Maadawy on 31/12/2023.
//

import Foundation

public final class OrcaEngine {
    
    // MARK: - Properties
    
    private let databaseProxy: DatabaseProxyProtocol
    private let nlpServices: NLPService
    private let machineEngine: MachineLearningEngine
    
    // MARK: - Initialization

    public init(reconfigure: Bool = false) throws {
                
        try self.databaseProxy = SQLiteDatabaseProxy.init(reconfigureDatabase: reconfigure)
        self.nlpServices = NLPService.init()
        self.machineEngine = MachineLearningEngine.init()
        
    }
}

public extension OrcaEngine {
    
    
    func extractKeywords(_ opportunity: OrcaOpportunity) throws {
        
        let values = nlpServices.extractData(dataBuffer: opportunity, extractAs: .keywords) as [OrcaKeyword]
        try databaseProxy.saveKeywords(values: values)
        
    }
    
}

public extension OrcaEngine {
    
    func trainModel() async throws {
        
        let nlpKeywords = [
            try self.databaseProxy.extractKeywords(whereSuitability: true),
           try self.databaseProxy.extractKeywords(whereSuitability: false)
        ].flatMap({$0})
        
        try await machineEngine.trainModel(nlpKeywords)
    }
    
    func scanOpportunity(_ postFullText: String) async throws -> Double {
       
        let scanTask = Task.init(priority: .userInitiated) { () -> Double in
            let opportunitySentences = nlpServices.extractData(dataBuffer: postFullText, extractAs: .sentences) as [String]

                        var suitablePercent = 0.00
            var notSuitablePercent = 0.00
            var totalLines = 0.00
            
            opportunitySentences.forEach { value in
                
                let confidence = self.machineEngine.query(value)
                
                if(confidence["True"]! != 0.5) {
                    
                    totalLines += 1
                    
                    suitablePercent += confidence["True"]!
                    notSuitablePercent += confidence["False"]!
                    
                }
            }
            
            let totalPercent = notSuitablePercent - suitablePercent
            return (100.00 - ((totalPercent/totalLines) * 100))
        }
        return try await scanTask.result.get()
    }
    

}
