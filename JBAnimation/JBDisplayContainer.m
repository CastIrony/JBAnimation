#import "NSArray+JBDiff.h"
#import "NSArray+Map.h"
#import "JBDisplayContainer.h"
#import "JBCompletionGroup.h"

@interface JBDisplayItemProxy : NSObject 

@property (nonatomic, weak) JBDisplayContainer* displayContainer;
@property (nonatomic, assign, getter=isAlive) BOOL alive; 
@property (nonatomic, assign, getter=isDead) BOOL dead; 
@property (nonatomic, copy) JBLayoutAnimationBlock layoutAnimationBlock;
@property (nonatomic, strong) id model;

@end

@implementation JBDisplayItemProxy

@end


@interface JBDisplayContainer () 

@property (nonatomic, copy) NSDictionary* dataStore;
@property (nonatomic, copy) NSDictionary* liveDictionary;
@property (nonatomic, copy) NSArray* keys;
@property (nonatomic, copy) NSArray* items;    
@property (nonatomic, copy) NSArray* models;    
@property (nonatomic, copy) NSArray* liveKeys;   
@property (nonatomic, copy) NSArray* liveItems;
@property (nonatomic, copy) NSArray* liveModels;

@end



@implementation JBDisplayContainer

-(instancetype)init
{
    self = [super init];
    
    if(self) 
    {
        _liveDictionary = @{};
        _dataStore      = @{};
        _keys           = @[];
        _items          = @[];
        _models         = @[];
        _liveKeys       = @[];
        _liveItems      = @[];
        _liveModels     = @[];
    }
    
    return self;
}

-(id<NSObject, NSCopying>)keyForModel:(id)model
{
    if([self.delegate respondsToSelector:@selector(displayContainer:keyForModel:)])
    {
        return [self.delegate displayContainer:self keyForModel:model];
    }
    else if([model conformsToProtocol:@protocol(NSObject)] && [model conformsToProtocol:@protocol(NSCopying)])
    {
        return (id<NSObject, NSCopying>)model;
    }
    return nil;
}

-(id<JBDisplayItem>)displayItemForModel:(id)model
{
    if([self.delegate respondsToSelector:@selector(displayContainer:displayItemForModel:)])
    {
        return [self.delegate displayContainer:self displayItemForModel:model];
    }
    else if([model conformsToProtocol:@protocol(JBDisplayItem)])
    {
        return (id)model;
    }
    
    return nil;
}

-(void)updateLayoutWithDuration:(NSTimeInterval)duration completion:(void(^)())completion
{
    [self updateLayoutForItems:self.liveItems newItemSet:[NSSet set] withDuration:duration completion:completion];
}

-(void)updateLayoutForItems:(NSArray*)items newItemSet:(NSSet*)newItemSet withDuration:(NSTimeInterval)duration completion:(void(^)())completion
{
    JBCompletionGroup* completionGroup = [JBCompletionGroup completionGroup];

    if(self.layoutDelegate)
    {
        id layoutToken = [completionGroup acquireToken];
        [self.layoutDelegate displayContainer:self needsLayoutForItems:items duration:duration completion:^{ [completionGroup redeemToken:layoutToken]; }];

        for(id<JBDisplayItem> item in items)
        {
            if(item.layoutAnimationBlock) 
            { 
                id updateToken = [completionGroup acquireToken];
                item.layoutAnimationBlock([newItemSet containsObject:item], duration, ^{ [completionGroup redeemToken:updateToken]; }); 
            }
        }
    }
    
    completionGroup.completion = completion;
}

-(void)updateWithModels:(NSArray *)models duration:(NSTimeInterval)duration completion:(void (^)())completion
{
    NSArray* newLiveKeys = [models arrayByMappingBlock:^(id model) { return [self keyForModel:model]; }];
    
    JBDiffResult* diffResult = [self.keys diffWithArray:newLiveKeys];
        
    JBCompletionGroup* completionGroup = [JBCompletionGroup completionGroup];
    
    NSMutableIndexSet* redundantIndexes = [NSMutableIndexSet indexSet];
    NSMutableArray* movedKeys = [NSMutableArray array];
    
    for(NSUInteger i = [diffResult.combinedDeletedIndexes firstIndex]; i != NSNotFound; i = [diffResult.combinedDeletedIndexes indexGreaterThanIndex:i]) 
    {
        NSString* deletedKey = (diffResult.combinedArray)[i];
        
        if([diffResult.insertedObjects containsObject:deletedKey])
        {
            [redundantIndexes addIndex:i];
            [movedKeys addObject:deletedKey];
        }
    }
    
    NSMutableArray* keys = [diffResult.combinedArray mutableCopy];
    NSMutableArray* missingKeys = [diffResult.deletedObjects mutableCopy];
    
    [keys removeObjectsAtIndexes:redundantIndexes];
    [missingKeys removeObjectsInArray:movedKeys];
    
    self.keys = keys;

    NSMutableDictionary* dictionary = [self.dataStore mutableCopy];

    for(NSString* key in missingKeys)
    {
        id<JBDisplayItem> item = [(self.dataStore)[key] lastObject];
        
        if(item.isAlive)
        { 
            NSString* token = [completionGroup acquireToken];
            
            [item disappearWithDuration:duration completion:^{ [completionGroup redeemToken:token]; }];
            
            NSAssert(item.isAlive == NO, @"Item %@ should not be alive", item);
        }
    }
    
    NSMutableSet* newItemSet = [NSMutableSet set];
    
    for(id model in models)
    {
        id<NSObject, NSCopying> key = [self keyForModel:model];
    
        NSMutableArray* items = [self.dataStore[key] mutableCopy] ?: [NSMutableArray array];
                        
        id<JBDisplayItem> oldItem = [[items lastObject] isAlive] ? [items lastObject] : nil;

        id updateToken = [completionGroup acquireToken];
        BOOL updateSuccess = [oldItem updateWithNewModel:model duration:duration completion:^{ [completionGroup redeemToken:updateToken]; }];

        if(!updateSuccess)
        {
            id<JBDisplayItem> newItem = [self displayItemForModel:model];
            newItem.displayContainer = self;
            [newItemSet addObject:newItem];

//            NSLog(@"%@ -> %@", model, newItem);
        
            if(oldItem)
            {
                if([newItem respondsToSelector:@selector(replaceOldItem:duration:completion:)])
                {
                    id replaceToken = [completionGroup acquireToken];
                    [newItem replaceOldItem:oldItem duration:duration completion:^{ [completionGroup redeemToken:replaceToken]; }];
                }
            }
        
            id appearToken = [completionGroup acquireToken];
            [newItem appearWithModel:model duration:duration completion:^{ [completionGroup redeemToken:appearToken]; }];
            
            if(oldItem)
            {
                id disappearToken = [completionGroup acquireToken];
                [oldItem disappearWithDuration:duration completion:^{ [completionGroup redeemToken:disappearToken]; }];
                
                NSAssert(oldItem.alive == NO, @"Item %@ should not be alive", oldItem);
            }
            
            [items addObject:newItem];
        }
        
        dictionary[key] = items;
    }
    
    self.dataStore = dictionary;

    [self generateItemLists];

    id layoutToken = [completionGroup acquireToken];
    [self updateLayoutForItems:self.liveItems newItemSet:newItemSet withDuration:duration completion:^{ [completionGroup redeemToken:layoutToken]; }];

    completionGroup.completion = completion;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%2X: %@", (int)self, [self.class description]];
}

-(NSString*)debugDescription
{
    if(self.dataStore.count > 0)
    {
        NSMutableString* description = [NSMutableString stringWithFormat:@"%@:\n{\n", self.description];
        
        for(id<NSObject, NSCopying> key in self.keys)
        {
            [description appendFormat:@"    '%@' => %@\n", key, [(self.dataStore)[key] debugDescription]];
        }
        
        [description appendString:@"}"];
        
        return description;
    }
    else 
    {
        return self.description;
    }
}

-(void)generateItemLists
{
    NSMutableDictionary* newLiveDictionary = [NSMutableDictionary dictionary];
    NSMutableArray*      newItems          = [NSMutableArray array];
    NSMutableArray*      newLiveItems      = [NSMutableArray array];
    NSMutableArray*      newLiveKeys       = [NSMutableArray array];
        
    for(id key in self.keys)
    {
        for(id<JBDisplayItem> item in (self.dataStore)[key])
        {
            if(item.isDead) { continue; }
                
            [newItems addObject:item];
        }
        
        id<JBDisplayItem> topItem = [(self.dataStore)[key] lastObject];
                
        if(topItem.isAlive)
        {
            newLiveDictionary[key] = topItem;
            [newLiveItems addObject:topItem];
            [newLiveKeys addObject:key];
        }
    }
    
    self.liveDictionary = newLiveDictionary;
    self.items          = newItems;
    self.liveItems      = newLiveItems;
    self.liveKeys       = newLiveKeys; 

    if(self.dataStore.count == 0 && self.keys.count == 0) { return; }

    NSMutableDictionary* newDataStore = [NSMutableDictionary dictionary];
    NSMutableArray* newKeys = [NSMutableArray array];
    
    for(NSString* key in self.keys)
    {
        BOOL allDead = YES;
    
        NSArray* itemList = (self.dataStore)[key];

        NSMutableArray* newItemList = [NSMutableArray array];

        for(id<JBDisplayItem> item in itemList)
        {
            if(!item.isDead)
            {
                [newItemList addObject:item];
                
                allDead = NO;
            }
        }
        
        if(!allDead)
        {
            newDataStore[key] = newItemList;
            [newKeys addObject:key];
        }
    }
        
    self.dataStore = newDataStore;
    self.keys = newKeys;
}

-(NSArray*)itemsForKey:(id)key 
{
    return (self.dataStore)[key]; 
}

-(id)liveItemForKey:(id)key 
{
    if(![self.liveKeys containsObject:key]) { return nil; }
    
    return [(self.dataStore)[key] lastObject];
}

@end