//
//  DemoRowView.h
//  JBAnimation
//
//  Created by Joel Bernstein on 6/19/14.
//  Copyright (c) 2014 Joel Bernstein. All rights reserved.
//

#import <JBAnimation/JBAnimation.h>

#import <UIKit/UIKit.h>

@interface DemoRowView : JBStackRow <JBDisplayItem>

@property (nonatomic, strong) IBOutlet UILabel* label;
@property (nonatomic, strong) IBOutlet UITextView* textView;

@end
