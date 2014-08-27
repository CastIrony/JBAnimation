//
//  JBStackRow.h
//  JBAnimation
//
//  Created by Joel Bernstein on 6/21/14.
//  Copyright (c) 2014 Joel Bernstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBAnimation.h"

@interface JBStackRow : UIView <JBDisplayItem>

@property (nonatomic, weak) JBDisplayContainer* displayContainer;
@property (nonatomic, copy) JBLayoutAnimationBlock layoutAnimationBlock;
@property (nonatomic, readonly, getter=isAlive) BOOL alive; 
@property (nonatomic, readonly, getter=isDead) BOOL dead; 
@property (nonatomic, strong, readonly) id model;

@end
