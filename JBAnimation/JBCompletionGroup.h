//
//  JBCompletionGroup.h
//  JBAnimation
//
//  Created by Joel Bernstein on 2/8/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JBCompletionGroup : NSObject

+(instancetype)completionGroup;

@property (nonatomic, copy) void(^completion)();

-(id)acquireToken;
-(void)redeemToken:(id)token;

@end
