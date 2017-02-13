//
//  CommandQueue.m
//  ChessEngine
//
//  Created by hengyu on 2017/2/11.
//  Copyright © 2017 hengyu. All rights reserved.
//

#import "CommandQueue.h"

@implementation CommandQueue

- (instancetype)init {
    if (self = [super init]) {
        contents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)isEmpty {
    return [self size] == 0;
}

- (int)size {
    return (int)[contents count];
}

- (id)front {
    return [contents objectAtIndex: 0];
}

- (id)back {
    return [contents lastObject];
}

- (void)push:(id)anObject {
    [contents addObject: anObject];
}

- (id)pop {
    id object = nil;
    if (![self isEmpty]) {
        object = [contents objectAtIndex: 0];
        [contents removeObjectAtIndex: 0];
    } else {
        // Queue undeflow
    }
    return object;
}

@end
