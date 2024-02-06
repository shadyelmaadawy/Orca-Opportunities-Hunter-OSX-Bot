//
//  ViewController.swift
//  MLChecker
//
//  Created by Shady El-Maadawy on 30/12/2023.
//

import Cocoa
import CoreML
import OrcaEngine

import Utilities

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    
    private let jsonDecoder = JsonDecoderEngine.init()
    
    @IBOutlet var jobTextField: NSTextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let x = try? String.init(contentsOfFile: URL.nlModelURL.path())
        if(x != nil) {
            
            self.currentState = .query


        } else {
            
            self.currentState = .train

        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    let engine = try! OrcaEngine.init()
    
    enum buttonState: Int {
        case train
        case query
    }
    
    var currentState: buttonState = .train {
        willSet {
            if(newValue == .query) {
                controllerButton.title = "Check"
                trainNew.isEnabled = true
            } else {
                controllerButton.isEnabled = true
            }
        }
    }
    @IBOutlet weak var controllerButton: NSButton!
    @IBOutlet weak var trainNew: NSButton!
    @IBAction func trainNewDataButton(_ sender: Any) {
    }
    
    @IBOutlet weak var checkReesultLabel: NSTextField!
    @IBAction func checkResultLabel(_ sender: Any) {
    }
    @IBAction func commanderButton(_ sender: Any) {
        
        switch(self.currentState) {
            case .train:
                
                do {
                    
                    Task.init(priority: .userInitiated) {
                        
                        guard let OpportunitiesURL = Bundle.main.path(forResource:"Opportunities", ofType: "json") else {
                            return
                        }
                        let jsonContent = try String.init(contentsOfFile: OpportunitiesURL)
                        
                        let jsonMap = try jsonDecoder.parse(from: jsonContent, as: [OrcaOpportunity].self)
                    
                        try jsonMap.forEach { orcaModel in
                            try engine.extractKeywords(orcaModel)
                        }
                    
                        try await engine.trainModel()
                        self.currentState = .query
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            case .query:
            
                guard let jobBuffer = jobTextField.textStorage?.string else {
                    return
                }

                Task.init {
                    
                    let scanResult = try await engine.scanOpportunity(jobBuffer)
                    DispatchQueue.main.async {
                        self.checkReesultLabel.stringValue = "Are you IOS Engineer? %\(scanResult)"
                    }
                }
        }
        
        
    }
}

