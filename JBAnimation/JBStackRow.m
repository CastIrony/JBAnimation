//
//  JBStackRow.m
//  JBAnimation
//
//  Created by Joel Bernstein on 6/21/14.
//  Copyright (c) 2014 Joel Bernstein. All rights reserved.
//

#import "JBStackRow.h"



@interface JBStackRow ()

@property (nonatomic, assign, getter=isAlive) BOOL alive; 
@property (nonatomic, assign, getter=isDead) BOOL dead; 
@property (nonatomic, strong) id model;
@property (nonatomic, assign) CGSize layoutSize;

@end



@implementation JBStackRow

-(void)appearWithModel:(id)model duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion
{
    self.model = model;
    self.alive = YES;
    self.dead = NO;

    self.alpha = 0;
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^
    {
        self.alpha = 1;
    } 
    completion:^(BOOL finished) 
    {
        if(completion) { completion(); }
    }];
}

-(BOOL)updateWithNewModel:(id)newModel duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion
{
    self.model = newModel;
    
    if(completion) { completion(); }
    
    return YES;
}

-(void)disappearWithDuration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion
{
    self.alive = NO;
        
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^
    {
        self.alpha = 0;
    } 
    completion:^(BOOL finished) 
    {
        self.dead = YES;
        [self removeFromSuperview];
        
        if(completion) { completion(); }
    }];
}

-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize
{
    if(CGSizeEqualToSize(self.layoutSize, CGSizeZero))
    {
        self.layoutSize = [super systemLayoutSizeFittingSize:targetSize];
    }
    
    return self.layoutSize;
}

@end
