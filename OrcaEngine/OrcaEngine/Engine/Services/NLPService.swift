//
//  NLPService.swift
//  OrcaEngine
//
//  Created by Shady El-Maadawy on 30/01/2024.
//

import Foundation
import NaturalLanguage

internal final class NLPService {
    
    
    // MARK: - Enums
    
    enum extractOperation {
        case sentences
        case keywords
    }

    // MARK: - NOTE, Algorithm under development
    
    /// Extract keywords from a text string, extracted words will be based on Natural Language Analysis, As Example: IOS, Core Animation.. etc, there is no extract from web-sources.
    /// - Parameter opportunity: post opportunity
    /// - Returns: array with keywords
    func extractData<T, S: Hashable>(dataBuffer: T, extractAs: extractOperation = .keywords) -> [S] {
        
        var keywordsBuffer: Set<S> = []
        keywordsBuffer.reserveCapacity(128)
        
        let tagger = NLTagger.init(tagSchemes: [
            .nameTypeOrLexicalClass,
        ])
        let options: NLTagger.Options = [
            .omitPunctuation,
            .omitWhitespace,
            .joinNames,
        ]
        
        let nonAcceptedTags: [NLTag] = [
            .verb,
            .adverb,
            .number,
            .pronoun,
            .particle,
            .preposition,
            .determiner,
            .conjunction,
            .interjection,
        ]
        
        var fullText = ""
        switch(extractAs) {
            
            case .keywords:
                fullText = (dataBuffer as! OrcaOpportunity).fullText
            case .sentences:
                fullText = dataBuffer as! String
        }
        let textRange = fullText.startIndex..<fullText.endIndex
        tagger.string = fullText
        
       
        let nlEmbedding = NLEmbedding.wordEmbedding(for: .english)!
        tagger.enumerateTags(
            in: textRange,
            unit: extractAs == .keywords ? .word : .paragraph,
            scheme: .nameTypeOrLexicalClass, options: options
        ) { tokenTag, tokenRange in
            
            guard let tokenTag = tokenTag else {
                return true
            }
            
            let extractedToken = String.init(
                fullText[tokenRange]
            ).lowercased()
            guard extractedToken.count > 2 else {
                return true
            }
            
            if(nonAcceptedTags.contains(tokenTag)) {
                return true
            }
            
            var isTechConcept = false
            
            if(tokenTag == .noun || tokenTag == .adjective || tokenTag == .personalName) {
                
                isTechConcept = nlEmbedding.neighbors(
                    for: extractedToken, maximumCount: 1
                ).isEmpty == true
                
            }
            else if (tokenTag == .placeName || tokenTag == .organizationName) {
                isTechConcept = true
            }
            else {
                isTechConcept = extractedToken.isContainsWhitespaces()
        }

            guard isTechConcept == true else {
                return true
            }

            switch(extractAs) {
                case .keywords:
                    keywordsBuffer.insert(
                        OrcaKeyword.init(
                            keywordValue: extractedToken,
                            isSuitable: (dataBuffer as! OrcaOpportunity).isSuitable
                        ) as! S
                    )
            case .sentences:
                    keywordsBuffer.insert(
                        extractedToken as! S
                    )
            }
            return true
        }
        return keywordsBuffer.map({$0})
    }
}

