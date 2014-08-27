//
//  DemoRowView.m
//  JBAnimation
//
//  Created by Joel Bernstein on 6/19/14.
//  Copyright (c) 2014 Joel Bernstein. All rights reserved.
//

#import "DemoRowView.h"



@implementation DemoRowView

-(void)appearWithModel:(id)model duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion
{
    NSString* fullText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar luctus dolor, eu congue mi eleifend quis. Fusce tincidunt, magna nec commodo malesuada, risus metus dignissim orci, sed porta enim justo et elit. Integer vestibulum, enim vel aliquet volutpat, eros augue commodo leo, id blandit leo enim id risus. Duis nisi magna, sagittis eget arcu eu, pulvinar aliquam sapien. In ut ipsum nec enim molestie dictum.";
    NSArray* fullTextArray = [fullText componentsSeparatedByString:@" "];
    NSArray* shortTextArray = [fullTextArray subarrayWithRange:NSMakeRange(0, fullTextArray.count * drand48())];
    NSString* shortText = [shortTextArray componentsJoinedByString:@" "];
    shortText = [NSString stringWithFormat:@"%@ ~", shortText];
    self.textView.text = shortText;

    [super appearWithModel:model duration:duration completion:completion];
}

-(BOOL)updateWithNewModel:(id)newModel duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion
{
    NSString* fullText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar luctus dolor, eu congue mi eleifend quis. Fusce tincidunt, magna nec commodo malesuada, risus metus dignissim orci, sed porta enim justo et elit. Integer vestibulum, enim vel aliquet volutpat, eros augue commodo leo, id blandit leo enim id risus. Duis nisi magna, sagittis eget arcu eu, pulvinar aliquam sapien. In ut ipsum nec enim molestie dictum.";
    NSArray* fullTextArray = [fullText componentsSeparatedByString:@" "];
    NSArray* shortTextArray = [fullTextArray subarrayWithRange:NSMakeRange(0, fullTextArray.count * drand48())];
    NSString* shortText = [shortTextArray componentsJoinedByString:@" "];
    shortText = [NSString stringWithFormat:@"%@ ~", shortText];
    self.textView.text = shortText;

    [super updateWithNewModel:newModel duration:duration completion:completion];
    
    return YES;
}

@end
