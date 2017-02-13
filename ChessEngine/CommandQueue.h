//
//  CommandQueue.h
//  ChessEngine
//
//  Created by hengyu on 2017/2/11.
//  Copyright © 2017 hengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandQueue: NSObject {
    NSMutableArray *contents;
}

- (instancetype)init;

- (BOOL)isEmpty;
- (int)size;
- (id)front;
- (id)back;
- (void)push:(id)object;
- (id)pop;

@end
