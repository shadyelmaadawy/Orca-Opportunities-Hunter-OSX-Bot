//
//  MachineLearningEngine.swift
//  OrcaEngine
//
//  Created by Shady El-Maadawy on 31/12/2023.
//

import CreateML
import TabularData
import Utilities
import CoreML
import NaturalLanguage

internal final class MachineLearningEngine {
    
    // MARK: - Enums
    
    enum ColumnIdentifier: String {
        case valueColumn = "keywordValue"
        case suitableColumn = "isSuitable"
    }
    
    // MARK: - Properties

    private let encoderEngine: JsonEncoderEngine
    
    private lazy var languageModel: NLModel = {
        
        let compiledURL = try! MLModel.compileModel(at: URL.nlModelURL)
        let machineModel = try! MLModel(
            contentsOf: compiledURL
        )
        let languageModel = try! NLModel(
            mlModel: machineModel
        )
        return languageModel
    }()

    internal init() {
        self.encoderEngine = JsonEncoderEngine.init()
    }
}

// MARK: - Operations

extension MachineLearningEngine {
    
    /// Train AI Model with new data
    /// - Parameter requiredBuffer: new data that will train model with
    func trainModel(_ requiredBuffer: [OrcaModel]) async throws {
        
        Task.init(priority: .medium) {
            let jsonData = try encoderEngine.encode(from: requiredBuffer)

            let tableDataFrame = try DataFrame.init(jsonData: jsonData)
            let textClassifier = try MLTextClassifier.init(
                trainingData: tableDataFrame,
                textColumn: ColumnIdentifier.valueColumn.rawValue,
                labelColumn: ColumnIdentifier.suitableColumn.rawValue
            )
            
            try textClassifier.write(
                to: URL.nlModelURL
            )

        }
    }

    /// Query about text if it's suitable or not
    /// - Parameter value: Text
    /// - Returns: True or false
    func query(_ value: String) -> [String: Double] {
        let confidences = languageModel.predictedLabelHypotheses(for: value, maximumCount: 2)
        return confidences
    }

}
