//
//  JBStackView.m
//  TransitTimer
//
//  Created by Joel Bernstein on 6/18/14.
//
//

#import "JBStackView.h"
#import "JBStackRow.h"



@interface JBStackView ()

@property (nonatomic, strong) JBDisplayContainer* displayContainer;

@end



const CGFloat margin = 0;

@implementation JBStackView

-(instancetype)init
{
    self = [super init];

    if(self)
    {
        _displayContainer = [[JBDisplayContainer alloc] init];
        _displayContainer.delegate = self;
        _displayContainer.layoutDelegate = self;
    }

    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];

    if(self)
    {
        _displayContainer = [[JBDisplayContainer alloc] init];
        _displayContainer.delegate = self;
        _displayContainer.layoutDelegate = self;
    }

    return self;
}

-(void)updateWithModels:(NSArray *)models duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion
{
    [self.displayContainer updateWithModels:models duration:duration completion:completion];
}

//-(void)setContentSize:(CGSize)contentSize
//{
//    [super setContentSize:contentSize];
//
//    [self invalidateIntrinsicContentSize];
//}

-(id<JBDisplayItem>)displayContainer:(JBDisplayContainer*)displayContainer displayItemForModel:(id)model
{
    if([self.delegate respondsToSelector:@selector(stackView:childViewForModel:)])
    {
        return [self.delegate stackView:self childViewForModel:model];
    }
    else if([model isKindOfClass:[JBStackRow class]])
    {
        return (JBStackRow*)model;
    }
    
    return nil;
}

-(id<NSObject, NSCopying>)displayContainer:(JBDisplayContainer*)displayContainer keyForModel:(id)model
{
    if([self.delegate respondsToSelector:@selector(stackView:keyForModel:)])
    {
        return [self.delegate stackView:self keyForModel:model];
    }
    else if([model conformsToProtocol:@protocol(NSObject)] && [model conformsToProtocol:@protocol(NSCopying)])
    {
        return (id<NSObject, NSCopying>)model;
    }
    
    return nil;
}

-(void)displayContainer:(JBDisplayContainer *)displayContainer needsLayoutForItems:(NSArray *)liveItems duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion
{
    CGFloat offsetY = 0;

    for(UIView<JBDisplayItem>* item in liveItems)
    {
        [item removeFromSuperview];
        item.translatesAutoresizingMaskIntoConstraints = NO;

        CGSize itemSize = [item systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

        item.translatesAutoresizingMaskIntoConstraints = YES;
        item.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:item];
        
        NSLog(@"model = %@, itemSize = %@", item.model, NSStringFromCGSize(itemSize));
        
        __weak UIView<JBDisplayItem>* weakItem = item;

        item.layoutAnimationBlock = ^(BOOL itemIsNew, NSTimeInterval duration, JBCompletionBlock completion)
        {
            __strong UIView<JBDisplayItem>* item = weakItem;
        
            if(itemIsNew)
            {
                item.frame = (CGRect){ (CGPoint){ 0, offsetY }, { self.bounds.size.width, itemSize.height } };
                if(completion) { completion(); }
            }
            else
            {
                [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^
                {
                    item.frame = (CGRect){ (CGPoint){ 0, offsetY }, { self.bounds.size.width, itemSize.height } };
                } 
                completion:^(BOOL finished) 
                {
                    if(completion) { completion(); }
                }];
            }
        };
        
        offsetY += itemSize.height;
    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width, offsetY);
    [self invalidateIntrinsicContentSize];
}

-(CGSize)intrinsicContentSize
{
    return self.contentSize;
}

@end
