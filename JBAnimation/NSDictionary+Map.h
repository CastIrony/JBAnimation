//
//  NSDictionary+Map.h
//  Surveyor
//
//  Created by Joel Bernstein on 12/20/13.
//  Copyright (c) 2013 Joel Bernstein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Map)

- (NSArray*)arrayByMappingBlock:(id(^)(id<NSCopying> key, id value))block;
- (NSSet*)setByMappingBlock:(id(^)(id<NSCopying> key, id value))block;
- (NSDictionary*)dictionaryByMappingKeyBlock:(id<NSCopying>(^)(id<NSCopying> key, id value))keyBlock valueBlock:(id(^)(id<NSCopying> key, id value))valueBlock;

@end
