//
//  OhWindowController.swift
//  OhKit
//
//  Created by Shady El-Maadawy on 17/12/2023.
//

import AppKit

public final class OhWindowController: NSWindowController {
    
    // MARK: - Initialization

    public init(rootViewController: OhViewController? = nil) {
        super.init(window: OhWindow.init())
        self.configure(rootViewController)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Configure

private extension OhWindowController {
    
    func configure(_ rootViewController: OhViewController?) {
        
        self.contentViewController = rootViewController
        
    }
    
}
