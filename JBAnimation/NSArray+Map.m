//
//  NSArray+Map.m
//  Surveyor
//
//  Created by Joel Bernstein on 12/20/13.
//  Copyright (c) 2013 Joel Bernstein. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

- (NSArray*)arrayByMappingBlock:(id(^)(id object))block
{    
    if(block) 
    {
        NSMutableArray* mappedArray = [NSMutableArray arrayWithCapacity:self.count];
        
        for(id object in self) 
        {
            id mappedObject = block(object);
            
            if(mappedObject) { [mappedArray addObject:mappedObject]; }
        }
        
        return [mappedArray copy];
    }
    
    return nil;
}

- (NSSet*)setByMappingBlock:(id(^)(id object))block
{    
    if(block) 
    {
        NSMutableSet* mappedSet = [NSMutableSet setWithCapacity:self.count];
        
        for(id object in self) 
        {
            id mappedObject = block(object);
            
            if(mappedObject) { [mappedSet addObject:mappedObject]; }
        }
        
        return [mappedSet copy];
    }
    
    return nil;
}

- (NSDictionary*)dictionaryByMappingKeyBlock:(id<NSCopying>(^)(id object))keyBlock
{
    return [self dictionaryByMappingKeyBlock:keyBlock valueBlock:nil];
}

- (NSDictionary*)dictionaryByMappingKeyBlock:(id<NSCopying>(^)(id object))keyBlock valueBlock:(id(^)(id object))valueBlock
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    if(keyBlock)
    {
        dictionary = [NSMutableDictionary dictionary];
        
        for(id object in self)
        {
            id<NSCopying> mappedKey = keyBlock(object);
            id mappedValue = valueBlock ? valueBlock(object) : object;
            
            if(mappedKey && mappedValue)
            {
                dictionary[mappedKey] = mappedValue;
            }
        }
    }
    
    return dictionary;
}

@end
