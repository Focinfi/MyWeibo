//
//  NSDictionary+Assemble.h
//  MyWeibo
//
//  Created by focinfi on 15/6/8.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Assemble)
- (NSString *) stringByJoinEntierWithSpaceCharacter:(NSString *) spaceCharacter andBoundary:(NSString *) boundary;
- (NSString *) stringByJoinSimplyrWithSpaceCharacter:(NSString *) spaceCharacter andBoundary:(NSString *) boundary;
- (void) eachPairDo:(void (^)(NSString *key, id value)) execute;

@end
