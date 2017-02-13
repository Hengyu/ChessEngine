# ChessEngine

`ChessEngine` is an open source chess engine framework for iOS. The internal ultra-strong chess engine is [Stockfish][1].

## Usage

### Installation
You have multiple choices to make use of `ChessEngine` framework:
- Copy `/ChessEngine/ChessEngine` to your project.
- Drag-n-drop _ChessEngine_ project to your project.
Carthage installation will be supported in the future.
### Quick start

Just a few lines of code:

	let engineManager: EngineManager = EngineManager()
	engineManager.delegate = self
	engineManager.gameFen = someGameFen
	engineManager.startAnalyzing()

### Delegate

	required public func engineManager(_ engineManager: EngineManager, didReceiveBestMove bestMove: String?, ponderMove: String?)
	
	optional public func engineManager(_ engineManager: EngineManager, didAnalyzeCurrentMove currentMove: String, number: Int, depth: Int)
	
	optional public func engineManager(_ engineManager: EngineManager, didReceivePrincipalVariation pv: String)
	
	optional public func engineManager(_ engineManager: EngineManager, didUpdateSearchingStatus searchingStatus: String)

## Related

ChessEngine framework is **heavily inspired** by the open sourced project _Stockfish for iOS_. I found this project has not been updated for a long time and it’s internal engine is `stockfish 6`, while the newest version of `stockfish` is 8. So I decided to create an iOS framework that uses `stockfish 8`. 
Since I am not very familiar with C++, I can’t build this framework the some ideas from _Stockfish for iOS_. 
**Thank you.**

## Contribution

Pull requests and issues are welcomed.  If the pull requests are related to [Stockfish][2] engine, please go to it’s page and make pull requests.

## License

GNU GENERAL PUBLIC LICENSE (Version 3).
You can go to `license` file to see the full version.



[1]:	https://stockfishchess.org
[2]:	https://stockfishchess.org