//
//  OhWindow.swift
//  OhKit
//
//  Created by Shady El-Maadawy on 17/12/2023.
//

import AppKit

public final class OhWindow: NSWindow {

    // MARK: - Initialization
    
    init() {
        
        super.init(
            contentRect: .defaultRect,
            styleMask: .defaultStyleMask,
            backing: .buffered,
            defer: false
        )
        self.configure()
    }
}

// MARK: - Configure

private extension OhWindow {
    
    func configure() {
        
        self.title = "Orca Opportunities Hunter OSX-Bot;"
        self.minSize = .minimumRect

        self.titlebarSeparatorStyle = .line
        self.titlebarAppearsTransparent = true
        
        self.appearance = NSAppearance.init(named: NSAppearance.Name.darkAqua)


    }
    
}
