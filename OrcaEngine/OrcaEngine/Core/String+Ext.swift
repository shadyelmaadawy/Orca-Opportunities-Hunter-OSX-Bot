//
//  String+Ext.swift
//  OrcaEngine
//
//  Created by Shady El-Maadawy on 13/01/2024.
//

import Foundation

internal extension String {
    func isContainsWhitespaces() -> Bool {
        return rangeOfCharacter(from: .whitespaces) != nil
    }
}
