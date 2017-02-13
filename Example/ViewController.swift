//
//  ViewController.swift
//  Example
//
//  Created by hengyu on 2017/2/13.
//  Copyright © 2017年 hengyu. All rights reserved.
//

import UIKit
import ChessEngine

let someGameFen: String = "position fen rnbqkbnr/pppp1ppp/8/4p3/3P4/8/PPP1PPPP/RNBQKBNR w KQkq -"
let someGameUCI: String = "position fen 2kr1bn1/ppp1q2p/2n2Q2/3p1b2/8/4P3/PPP2PPP/RNBQKBNR w KQ - moves e2e4 d7d5 e4d5 e7e5 d5e6 f8d6"

class ViewController: UIViewController, EngineManagerDelegate {
    
    let engineManager: EngineManager = EngineManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        engineManager.delegate = self
        engineManager.gameFen = someGameFen
        engineManager.startAnalyzing()
        
        let time = DispatchTime.now() + DispatchTimeInterval.seconds(2)
        DispatchQueue.global().asyncAfter(deadline: time, execute: {
            self.engineManager.stopAnalyzing()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: EngineManagerDelegate
    
    func engineManager(_ engineManager: EngineManager, didReceivePrincipalVariation pv: String) {
        print("PV: \(pv)")
    }
    
    func engineManager(_ engineManager: EngineManager, didUpdateSearchingStatus searchingStatus: String) {
        print("Searching status: \(searchingStatus)")
    }
    
    func engineManager(_ engineManager: EngineManager, didReceiveBestMove bestMove: String?, ponderMove: String?) {
        if let bestMove = bestMove {
            print("Best move is \(bestMove)")
        } else {
            print("No available moves")
        }
    }
    
    func engineManager(_ engineManager: EngineManager, didAnalyzeCurrentMove currentMove: String, number: Int, depth: Int) {
        
    }
}

