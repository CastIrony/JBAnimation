//
//  NSArray+Map.h
//  Surveyor
//
//  Created by Joel Bernstein on 12/20/13.
//  Copyright (c) 2013 Joel Bernstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray*)arrayByMappingBlock:(id (^)(id))block;
- (NSSet*)setByMappingBlock:(id(^)(id object))block;
- (NSDictionary*)dictionaryByMappingKeyBlock:(id<NSCopying>(^)(id object))keyBlock;
- (NSDictionary*)dictionaryByMappingKeyBlock:(id<NSCopying>(^)(id object))keyBlock valueBlock:(id(^)(id object))valueBlock;

@end
