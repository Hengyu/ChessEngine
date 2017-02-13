//
//  EngineManager.h
//  ChessEngine
//
//  Created by hengyu on 2017/2/13.
//  Copyright © 2017 hengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EngineManager;


/**
 This protocol represents the analyzing information of an `EngineManager`'s internal chess engine.
 */
@protocol EngineManagerDelegate <NSObject>

@required


/**
 A best move and a corresponding ponder move is received. This method will be triggered when the method `startAnalyzing` is called on an engineManager.

 @param engineManager Manager that manages the internal chess engine.
 @param bestMove The best move among the moves that has been analyzed. May be nil if there has no available moves.
 @param ponderMove The corresponding ponder move. May be nil if it doesn't exist or the internal chess engine does not enable the ponder option.
 */
- (void)engineManager:(nonnull EngineManager *)engineManager didReceiveBestMove:(nullable NSString *)bestMove ponderMove: (nullable NSString *)ponderMove;

@optional


/**
 The currently analyzed move, with it's number and search depth. This method will be called multiple times.

 @param engineManager Manager that manages the internal chess engine.
 @param currentMove Move that been analyzed currently.
 @param number Number of the move.
 @param depth Search depth of the move.
 */
- (void)engineManager:(nonnull EngineManager *)engineManager didAnalyzeCurrentMove:(nonnull NSString *)currentMove number:(NSInteger)number depth:(NSInteger)depth;


/**
 The engine manager received the pricinple variation from it's internal chess engine.

 @param engineManager Manager that manages the internal chess engine.
 @param pv Principal variation.
 */
- (void)engineManager:(nonnull EngineManager *)engineManager didReceivePrincipalVariation:(nonnull NSString *)pv;


/**
 The searching status of the internal chess engine is updated. This method will be called multiple times.

 @param engineManager Manager that manages the internal chess engine.
 @param searchingStatus Current searching status.
 */
- (void)engineManager:(nonnull EngineManager *)engineManager didUpdateSearchingStatus:(nonnull NSString *)searchingStatus;

@end


/**
 A class that manages a chess engine.
 */
@interface EngineManager : NSObject

/**
 The object that acts as the delegate of the `EngineManager`.
 The delegate must adopt the `EngineManagerDelegate` protocol. The delegate is not retained.
 */
@property (weak, nonatomic, nullable) id<EngineManagerDelegate> delegate;

/**
 The FEN string of a chess game. The FEN must follow the specification, otherwise, an exception will be raised.
 */
@property (strong, nonatomic, nullable) NSString *gameFen;

/**
 Number of principle variations. Default value is 1, and the value should not less than 1.
 */
@property (assign, nonatomic) NSUInteger numberOfPrincipalVariations;

/**
 Whether the internal chess engine is analyzing.
 */
@property (readonly, nonatomic) BOOL isAnalyzing;

/**
 Initialize an `EngineManager` instance.

 @return An initialized `EngineManager` instance.
 */
- (nonnull instancetype)init;

/**
 Start the internal chess engine. This method is called automatically when an `EngineManager` instance is created.
 */
- (void)startEngine;

/**
 Shutdown the internal chess engine. This method is called automatically when the `EngineManager` instance is about to release.
 */
- (void)shutdownEngine;

/**
 Informs the internal chess engine to start analyzing the `chessFen`. You should set the `gameFen` before calling this method.
 */
- (void)startAnalyzing;

/**
 Informs the internal chess engine to stop analyzing. And returns the best move and ponder move by delegate.
 */
- (void)stopAnalyzing;

@end
