//
//  EngineController.h
//  ChessEngine
//
//  Created by hengyu on 2017/2/11.
//  Copyright © 2017 hengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EngineController;

// For internal use
extern EngineController *SharedEngineController;

@protocol EngineControllerDelegate <NSObject>

//- (void)engineController:(EngineController *)engineController didReceiveEngineName:(NSString *)engineName;
- (void)engineController:(EngineController *)engineController didReceiveBestMove:(NSString *)bestMove ponderMove: (NSString *)ponderMove;
- (void)engineController:(EngineController *)engineController didAnalyzeCurrentMove:(NSString *)currentMove number:(NSInteger)number depth:(NSInteger)depth;
// https://chessprogramming.wikispaces.com/Principal+variation
- (void)engineController:(EngineController *)engineController didReceivePrincipalVariation:(NSString *)pv;
- (void)engineController:(EngineController *)engineController didUpdateSearchingStatus:(NSString *)searchingStatus;

@end

@interface EngineController : NSObject

@property (assign, nonatomic) id<EngineControllerDelegate> delegate;
@property (strong, nonatomic) NSString *gameFen;

/**
 Number of principle variations. Default value is 1, and the value should not less than 1.
 */
@property (assign, nonatomic) NSUInteger numberOfPrincipalVariations;

/**
 Whether the internal chess engine is analyzing.
 */
@property (readonly, nonatomic) BOOL isAnalyzing;

/**
 Whether the thread in which the internal chess engine is running.
 */
@property (readonly, nonatomic) BOOL isEngineThreadRunning;


- (instancetype)init;

- (void)startEngine;
- (void)shutdownEngine;
- (void)startAnalyzing;
- (void)stopAnalyzing;

// For internal use

- (void)unassociateWithGlobalInstance;
//- (void)sendCommand:(NSString *)command;
//- (void)commitCommands;
//- (void)setOption:(NSString *)name value:(NSString *)value;
- (void)setPlayStyle:(NSString *)style;
- (BOOL)commandIsWaiting;

- (void)sendBestMove:(NSString *)bestMove ponderMove:(NSString *)ponderMove;
- (void)sendCurrentMove:(NSString *)currentMove number:(NSInteger)number depth:(NSInteger)depth totalMoves:(NSInteger)total;
- (void)sendPrincipalVariation:(NSString *)pv;
- (void)sendSearchingStatus:(NSString *)searchStats;

@end
