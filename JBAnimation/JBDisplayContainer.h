//
//  JBDisplayContainer.h
//  JBAnimation
//
//  Created by Joel Bernstein on 2/8/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//

@class JBDisplayContainer;



typedef void(^JBCompletionBlock)();
typedef void(^JBLayoutAnimationBlock)(BOOL itemIsNew, NSTimeInterval duration, JBCompletionBlock completion);



@protocol JBDisplayItem <NSObject>

@property (nonatomic, weak) JBDisplayContainer* displayContainer;
@property (nonatomic, copy) JBLayoutAnimationBlock layoutAnimationBlock;
@property (nonatomic, readonly, getter=isAlive) BOOL alive; 
@property (nonatomic, readonly, getter=isDead) BOOL dead; 
@property (nonatomic, readonly) id model;

-(void)appearWithModel:(id)model duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion;
-(BOOL)updateWithNewModel:(id)newModel duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion;
-(void)disappearWithDuration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion;

@optional

-(void)replaceOldItem:(id<JBDisplayItem>)oldItem duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion;

@end



@protocol JBDisplayContainerDelegate <NSObject>

@optional

-(id<JBDisplayItem>)displayContainer:(JBDisplayContainer*)displayContainer displayItemForModel:(id)model;
-(id<NSObject, NSCopying>)displayContainer:(JBDisplayContainer*)displayContainer keyForModel:(id)model;

@end



@protocol JBDisplayContainerLayoutDelegate <NSObject>

-(void)displayContainer:(JBDisplayContainer*)displayContainer needsLayoutForItems:(NSArray*)liveItems duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion;

@end



/// Display container stores, manages, and updates a collection of objects. 
/// Stored objects must conform to DisplayItem protocol
@interface JBDisplayContainer : NSObject <JBDisplayContainerDelegate>

/// A dictionary mapping live keys to live objects. Generated once every time the display container is updated.
@property (nonatomic, copy, readonly) NSDictionary* liveDictionary;

/// An array of all keys. Generated once every time the display container is updated.
@property (nonatomic, copy, readonly) NSArray* keys;

/// An array of all display items. Generated once every time the display container is updated.
@property (nonatomic, copy, readonly) NSArray* items;

/// An array of models for all display items. Generated once every time the display container is updated.
@property (nonatomic, copy, readonly) NSArray* models;

/// An array of all keys with live display items. Generated once every time the display container is updated.
@property (nonatomic, copy, readonly) NSArray* liveKeys;

/// An array of all live display items. Generated once every time the display container is updated.
@property (nonatomic, copy, readonly) NSArray* liveItems;

/// An array of models for all live display items. Generated once every time the display container is updated.
@property (nonatomic, copy, readonly) NSArray* liveModels;

/// The delegate manages display items
@property (nonatomic, weak) id<JBDisplayContainerDelegate> delegate;

/// The layout delegate handles display item layout
@property (nonatomic, weak) id<JBDisplayContainerLayoutDelegate> layoutDelegate;

/// Returns an NSArray containing all items for key
-(NSArray*)itemsForKey:(id<NSObject, NSCopying>)key;

/// Returns the live item for key if available, or returns nil if unavailable
-(id<JBDisplayItem>)liveItemForKey:(id<NSObject, NSCopying>)key;

/// Updates the display container with new models.
-(void)updateWithModels:(NSArray*)models duration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion;

/// Updates layout for all live items;
-(void)updateLayoutWithDuration:(NSTimeInterval)duration completion:(JBCompletionBlock)completion;

@end