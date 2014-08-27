//
//  JBDisplayContainerStackView.h
//  TransitTimer
//
//  Created by Joel Bernstein on 6/18/14.
//
//

#import <UIKit/UIKit.h>
#import "JBDisplayContainer.h"



@class JBStackView;
@class JBStackRow;



@protocol JBStackViewDelegate <NSObject>

@optional

-(JBStackRow*)stackView:(JBStackView*)stackView childViewForModel:(id)model;
-(id<NSObject, NSCopying>)stackView:(JBStackView*)stackView keyForModel:(id)model;

@end



@interface JBStackView : UIScrollView <JBDisplayContainerDelegate, JBDisplayContainerLayoutDelegate>

@property (nonatomic, weak) id<JBStackViewDelegate, UIScrollViewDelegate> delegate;

-(void)updateWithModels:(NSArray*)models duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion;

@end
