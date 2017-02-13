//
//  EngineManager.m
//  ChessEngine
//
//  Created by hengyu on 2017/2/13.
//  Copyright © 2017 hengyu. All rights reserved.
//

#import "EngineManager.h"
#import "EngineController.h"

@interface EngineManager ()<EngineControllerDelegate>

@property (strong, nonatomic) EngineController *engineController;

@end

@implementation EngineManager

- (instancetype)init {
    if (self = [super init]) {
        _engineController = [[EngineController alloc] init];
        [_engineController setDelegate:self];
        [_engineController startEngine];
    }
    return self;
}

- (void)dealloc {
    [_engineController setDelegate:nil];
    [_engineController shutdownEngine];
    [_engineController unassociateWithGlobalInstance];
    _engineController = nil;
}

- (void)setNumberOfPrincipalVariations:(NSUInteger)numberOfPrincipalVariations {
    if (numberOfPrincipalVariations < 1) {
        return;
    }
    
    if (_numberOfPrincipalVariations != numberOfPrincipalVariations) {
        [_engineController setNumberOfPrincipalVariations:numberOfPrincipalVariations];
    }
}

- (void)setGameFen:(NSString *)gameFen {
    if (_gameFen != gameFen) {
        _gameFen = gameFen;
        _engineController.gameFen = gameFen;
    }
}

- (BOOL)isAnalyzing {
    return _engineController.isAnalyzing;
}

- (void)startEngine {
    [_engineController startEngine];
}

- (void)shutdownEngine {
    [_engineController shutdownEngine];
}

- (void)startAnalyzing {
    [_engineController startAnalyzing];
}

- (void)stopAnalyzing {
    [_engineController stopAnalyzing];
}

- (void)engineController:(EngineController *)engineController didUpdateSearchingStatus:(NSString *)searchingStatus {
    if (_delegate && [_delegate respondsToSelector:@selector(engineManager:didUpdateSearchingStatus:)]) {
        [_delegate engineManager:self didUpdateSearchingStatus:searchingStatus];
    }
}

- (void)engineController:(EngineController *)engineController didReceivePrincipalVariation:(NSString *)pv {
    if (_delegate && [_delegate respondsToSelector:@selector(engineManager:didReceivePrincipalVariation:)]) {
        [_delegate engineManager:self didReceivePrincipalVariation:pv];
    }
}

- (void)engineController:(EngineController *)engineController didReceiveBestMove:(NSString *)bestMove ponderMove:(NSString *)ponderMove {
    if (_delegate && [_delegate respondsToSelector:@selector(engineManager:didReceiveBestMove:ponderMove:)]) {
        [_delegate engineManager:self didReceiveBestMove:bestMove ponderMove:ponderMove];
    }
}

- (void)engineController:(EngineController *)engineController didAnalyzeCurrentMove:(NSString *)currentMove number:(NSInteger)number depth:(NSInteger)depth {
    if (_delegate && [_delegate respondsToSelector:@selector(engineManager:didAnalyzeCurrentMove:number:depth:)]) {
        [_delegate engineManager:self didAnalyzeCurrentMove:currentMove number:number depth:depth];
    }
}

@end
