//
//  JBCompletionGroup.m
//
//  Created by Joel Bernstein on 2/8/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//



#import "JBCompletionGroup.h"



@interface JBCompletionGroup ()

@property (nonatomic, retain) NSMutableSet* tokens;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) NSInteger lastToken;

@end




@implementation JBCompletionGroup

+(instancetype)completionGroup
{
    id completionGroup = [[JBCompletionGroup alloc] init];
    
    return completionGroup;
}

-(void)setCompletion:(void (^)())completion
{
    _completion = [completion copy];
    
    [self checkTokens];
}

-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        self.tokens = [NSMutableSet set];
        
        self.queue = dispatch_queue_create("TokenBag", NULL);
    }
    
    return self;
}

-(id)acquireToken
{
    __block id token;
    
    dispatch_sync(self.queue, ^
    {
        token = @(++self.lastToken);
        [self.tokens addObject:token];
    });
    
    return token;
}

-(void)redeemToken:(id)token
{
    dispatch_async(self.queue, ^
    { 
        [self.tokens removeObject:token];
        [self checkTokens];
    });
}

-(void)checkTokens
{
    dispatch_async(self.queue, ^
    {         
        if(self.tokens.count == 0 && self.completion)
        {            
            dispatch_sync(dispatch_get_main_queue(), self.completion);
            
            self.completion = nil;
        }
    });
}

@end
