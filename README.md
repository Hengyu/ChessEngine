# ChessEngine

`ChessEngine` is an open source chess engine framework for iOS. The internal ultra-strong chess engine is [Stockfish][1].

# Usage

## Installation

You have multiple choices to make use of `ChessEngine` framework.
- Copy `/ChessEngine/ChessEngine` to your project.
- Drag-n-drop _ChessEngine_ project to your project.
Carthage installation will be supported in the future.

## Quick start

Just a few lines of code:

```swift
import ChessEngine
// ..some code..
let engineManager: EngineManager = EngineManager()
engineManager.delegate = self
engineManager.gameFen = someGameFen
engineManager.startAnalyzing()
```

## Delegate

```swift
required public func engineManager(_ engineManager: EngineManager, didReceiveBestMove bestMove: String?, ponderMove: String?)
 
optional public func engineManager(_ engineManager: EngineManager, didAnalyzeCurrentMove currentMove: String, number: Int, depth: Int)

optional public func engineManager(_ engineManager: EngineManager, didReceivePrincipalVariation pv: String)

optional public func engineManager(_ engineManager: EngineManager, didUpdateSearchingStatus searchingStatus: String)
```

# Related

ChessEngine framework is **inspired** by the open sourced project [Stockfish for iOS][2], it’s source code can be downloaded from [here][3]. I found this project has not been updated for a long time and it’s internal engine is `stockfish 6`, while the latest version is `stockfish 8`. So I decided to create an iOS framework that uses `stockfish 8`. 

**Thanks.**

Stockfish for macOS can be found here [stockfish-mac][4].

# Contribution

Pull requests and issues are welcomed.  If the pull requests are related to [Stockfish][5] engine, please go to it’s page and make pull requests.

# License

GNU GENERAL PUBLIC LICENSE (Version 3).
You can go to `license` file to see the full version.



[1]:	https://stockfishchess.org
[2]:	https://itunes.apple.com/us/app/stockfish-chess/id305558605?mt=8
[3]:	https://stockfish.s3.amazonaws.com/stockfish-2.13-ios-src.zip
[4]:	https://github.com/daylen/stockfish-mac
[5]:	https://stockfishchess.org