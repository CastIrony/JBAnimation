//
//  NSDictionary+Map.m
//  Surveyor
//
//  Created by Joel Bernstein on 12/20/13.
//  Copyright (c) 2013 Joel Bernstein. All rights reserved.
//

#import "NSDictionary+Map.h"

@implementation NSDictionary (Map)

- (NSArray*)arrayByMappingBlock:(id(^)(id<NSCopying> key, id value))block
{    
    if(block) 
    {
        NSMutableArray* mappedArray = [NSMutableArray arrayWithCapacity:self.count];
        
        for(id<NSCopying> key in self.keyEnumerator) 
        {
            id value = self[key];
        
            if(value)
            {
                id mappedObject = block(key, value);
                
                if(mappedObject) { [mappedArray addObject:mappedObject]; }
            }
        }
        
        return [mappedArray copy];
    }
    
    return nil;
}

- (NSSet*)setByMappingBlock:(id(^)(id<NSCopying> key, id value))block
{    
    if(block) 
    {
        NSMutableSet* mappedSet = [NSMutableSet setWithCapacity:self.count];
        
        for(id<NSCopying> key in self.keyEnumerator) 
        {
            id value = self[key];
        
            if(value)
            {
                id mappedObject = block(key, value);
                
                if(mappedObject) { [mappedSet addObject:mappedObject]; }
            }
        }
        
        return [mappedSet copy];
    }
    
    return nil;
}

-(NSDictionary*)dictionaryByMappingKeyBlock:(id<NSCopying>(^)(id<NSCopying> key, id value))keyBlock valueBlock:(id(^)(id<NSCopying> key, id value))valueBlock
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for(id key in self.allKeys)
    {
        id mappedKey = keyBlock ? keyBlock(key, self[key]) : key;
        id mappedValue = valueBlock ? valueBlock(key, self[key]) : self[key];
        
        if(mappedKey && mappedValue)
        {
            [dictionary setValue:mappedValue forKey:mappedKey];
        }
    }
    
    return dictionary;
}

@end
