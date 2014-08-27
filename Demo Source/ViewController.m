//
//  ViewController.m
//  JBAnimation
//
//  Created by Joel Bernstein on 6/19/14.
//  Copyright (c) 2014 Joel Bernstein. All rights reserved.
//

#import "ViewController.h"
#import "DemoRowView.h"


@interface ViewController ()
            
@property (nonatomic, strong) IBOutlet JBStackView* stackView;

@end



@implementation ViewController

-(NSArray*)itemArray
{
    NSMutableArray* array = [NSMutableArray array];
    
    for(NSInteger i = 0; i < 20; i++)
    {
        if(drand48() > 0.8) { continue; }
        
        [array addObject:@(i)];
    }
    
    return array;
}

-(void)viewDidLoad 
{
    [super viewDidLoad];

    self.stackView.delegate = self;
    self.stackView.scrollEnabled = NO;

    [self.stackView updateWithModels:[self itemArray] duration:0 completion:nil];
}

-(UIView<JBDisplayItem> *)stackView:(JBStackView*)stackView childViewForModel:(id)model
{
    DemoRowView* demoRowView = [[[UINib nibWithNibName:NSStringFromClass([DemoRowView class]) bundle:nil] instantiateWithOwner:self options:0] firstObject];

    CGFloat hue = drand48();
    
    demoRowView.backgroundColor = [UIColor colorWithHue:hue saturation:0.5 brightness:1 alpha:1];
    demoRowView.textView.textColor = [UIColor colorWithHue:hue saturation:1 brightness:0.5 alpha:1];
    demoRowView.label.text = [model description];
    [demoRowView layoutIfNeeded];
    
    return demoRowView;
}

-(IBAction)reloadButtonTapped:(UIButton*)sender
{
    [self.stackView updateWithModels:[self itemArray] duration:0.8 completion:nil];
}

@end
