//
//  EngineController.m
//  ChessEngine
//
//  Created by hengyu on 2017/2/11.
//  Copyright © 2017 hengyu. All rights reserved.
//

#import "EngineController.h"
#import "CommandQueue.h"
#include <pthread.h>
#include "iosextension.h"

EngineController *SharedEngineController; 

@implementation EngineController {
    CommandQueue *commandQueue;
    NSThread *thread;
    pthread_cond_t waitCondition;
    pthread_mutex_t waitConditionLock;
    BOOL engineThreadShouldStop;
    BOOL ignoresBestMove;
}

#pragma mark Initialization

- (instancetype)init {
    if (self = [super init]) {
        commandQueue = [[CommandQueue alloc] init];
        
        // Initialize locks and conditions
        pthread_mutex_init(&waitConditionLock, NULL);
        pthread_cond_init(&waitCondition, NULL);
        
        _isAnalyzing = NO;
        _numberOfPrincipalVariations = 1;
        engineThreadShouldStop = NO;
        ignoresBestMove = NO;
        
        //        thread = [[NSThread alloc] initWithTarget: self selector: @selector(_startEngine) object: nil];
        //        [thread setStackSize: 0x100000];
        //        [thread start];
        
        //        [self sendCommand: @"isready"];
        //        [self sendCommand: @"ucinewgame"];
        
    }
    SharedEngineController = self;
    return self;
}

- (void)dealloc {
    pthread_cond_destroy(&waitCondition);
    pthread_mutex_destroy(&waitConditionLock);
}

#pragma mark Commands

- (void)sendCommand:(NSString *)command {
    [commandQueue push:command];
}

- (void)commitCommands {
    pthread_mutex_lock(&waitConditionLock);
    pthread_cond_signal(&waitCondition);
    pthread_mutex_unlock(&waitConditionLock);
}

- (void)setPlayStyle:(NSString *)style {
    if ([style isEqualToString: @"Passive"]) {
        [self setOption: @"Mobility (Midgame)" value: @"40"];
        [self setOption: @"Mobility (Endgame)" value: @"40"];
        [self setOption: @"Space" value: @"0"];
        [self setOption: @"Cowardice" value: @"150"];
        [self setOption: @"Aggressiveness" value: @"40"];
    } else if ([style isEqualToString: @"Solid"]) {
        [self setOption: @"Mobility (Midgame)" value: @"80"];
        [self setOption: @"Mobility (Endgame)" value: @"80"];
        [self setOption: @"Space" value: @"70"];
        [self setOption: @"Cowardice" value: @"150"];
        [self setOption: @"Aggressiveness" value: @"80"];
    } else if ([style isEqualToString: @"Active"]) {
        [self setOption: @"Mobility (Midgame)" value: @"100"];
        [self setOption: @"Mobility (Endgame)" value: @"100"];
        [self setOption: @"Space" value: @"100"];
        [self setOption: @"Cowardice" value: @"100"];
        [self setOption: @"Aggressiveness" value: @"100"];
    } else if ([style isEqualToString: @"Aggressive"]) {
        [self setOption: @"Mobility (Midgame)" value: @"120"];
        [self setOption: @"Mobility (Endgame)" value: @"120"];
        [self setOption: @"Space" value: @"120"];
        [self setOption: @"Cowardice" value: @"100"];
        [self setOption: @"Aggressiveness" value: @"150"];
    } else if ([style isEqualToString: @"Suicidal"]) {
        [self setOption: @"Mobility (Midgame)" value: @"150"];
        [self setOption: @"Mobility (Endgame)" value: @"150"];
        [self setOption: @"Space" value: @"150"];
        [self setOption: @"Cowardice" value: @"80"];
        [self setOption: @"Aggressiveness" value: @"200"];
    } else {
        //NSLog(@"Unknown play style: %@", style);
    }
}

- (void)setOption:(NSString *)name value:(NSString *)value {
    [self sendCommand: [NSString stringWithFormat: @"setoption name %@ value %@", name, value]];
}

#pragma mark Public methods

- (void)startAnalyzing {
    self.isAnalyzing = YES;
}

- (void)stopAnalyzing {
    self.isAnalyzing = NO;
}

- (void)startEngine {
    if (!thread) {
        [self sendCommand:@"uci"];
        [self setOption:@"Skill Level" value:@"20"];
        engineThreadShouldStop = NO;
        ignoresBestMove = NO;
        thread = [[NSThread alloc] initWithTarget: self selector: @selector(_startEngine) object: nil];
        [thread setStackSize: 0x100000];
        [thread start];
    }
}

- (void)_startEngine {
    _isEngineThreadRunning = YES;
    
    engine_init();
    
    while (!engineThreadShouldStop) {
        pthread_mutex_lock(&waitConditionLock);
        if ([commandQueue isEmpty]) {
            pthread_cond_wait(&waitCondition, &waitConditionLock);
        }
        pthread_mutex_unlock(&waitConditionLock);
        
        while (![commandQueue isEmpty]) {
            NSString *command = [commandQueue pop];
            //NSLog(@"Executing command: %@", command);
            execute_command(std::string([command UTF8String]));
            
            if ([command isEqualToString:@"quit"]) {
                engineThreadShouldStop = YES;
            }
        }
    }
    
    //NSLog(@"engine is quitting");
    engine_exit();
    
    _isEngineThreadRunning = NO;
    
    [thread cancel];
    thread = nil;
}

- (void)shutdownEngine {
    ignoresBestMove = YES;
    [self sendCommand:@"quit"];
    [self commitCommands];
}

#pragma mark Setters

- (void)setNumberOfPrincipalVariations:(NSUInteger)numberOfPrincipalVariations {
    if (numberOfPrincipalVariations < 1) {
        return;
    }
    
    if (_isAnalyzing) {
        self.isAnalyzing = NO;
        _numberOfPrincipalVariations = numberOfPrincipalVariations;
        self.isAnalyzing = YES;
    } else {
        _numberOfPrincipalVariations = numberOfPrincipalVariations;
    }
}

- (void)setGameFen:(NSString *)chessGameFen {
    if (_isAnalyzing) {
        self.isAnalyzing = NO;
        _gameFen = chessGameFen;
        self.isAnalyzing = YES;
    } else {
        _gameFen = chessGameFen;
    }
}

- (void)setIsAnalyzing:(BOOL)isAnalyzing {
    if (_isAnalyzing != isAnalyzing) {
        _isAnalyzing = isAnalyzing;
        if (isAnalyzing) {
            [self setOption:@"MultiPV" value:[NSString stringWithFormat:@"%lu", (unsigned long)_numberOfPrincipalVariations]];
            [self sendCommand:_gameFen];
            [self sendCommand:@"go infinite"];
            [self commitCommands];
        } else {
            [self sendCommand:@"stop"];
            [self commitCommands];
        }
    }
}

#pragma Internal methods

- (void)unassociateWithGlobalInstance {
    SharedEngineController = nil;
}

- (void)sendBestMove:(NSString *)bestMove ponderMove:(NSString *)ponderMove {
    if (!ignoresBestMove) {
        if (_delegate && [_delegate respondsToSelector:@selector(engineController:didReceiveBestMove:ponderMove:)]) {
            [_delegate engineController:self didReceiveBestMove:bestMove ponderMove:ponderMove];
        }
    } else {
        ignoresBestMove = NO;
    }
}

- (void)sendCurrentMove:(NSString *)currentMove number:(NSInteger)number depth:(NSInteger)depth totalMoves:(NSInteger)total {
    if (!currentMove) {
        currentMove = @"";
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(engineController:didAnalyzeCurrentMove:number:depth:)]) {
        [_delegate engineController:self didAnalyzeCurrentMove:currentMove number:number depth:depth];
    }
}

- (void)sendPrincipalVariation:(NSString *)pv {
    if (!pv) {
        pv = @"";
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(engineController:didReceivePrincipalVariation:)]) {
        [_delegate engineController:self didReceivePrincipalVariation:pv];
    }
}

- (void)sendSearchingStatus:(NSString *)searchStats {
    if (!searchStats) {
        searchStats = @"";
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(engineController:didUpdateSearchingStatus:)]) {
        [_delegate engineController:self didUpdateSearchingStatus:searchStats];
    }
    
}

- (BOOL)commandIsWaiting {
    return ![commandQueue isEmpty];
}

@end
