//
//  NSArray+JBDiff.h
//  Tyche
//
//  Created by Joel Bernstein on 3/19/10.
//



#import <Foundation/Foundation.h>



@interface JBDiffResult : NSObject

@property (nonatomic, copy) NSArray* firstArray;
@property (nonatomic, copy) NSArray* secondArray;
@property (nonatomic, copy) NSArray* lcsArray;
@property (nonatomic, copy) NSArray* combinedArray;

@property (nonatomic, copy) NSArray* deletedObjects;
@property (nonatomic, copy) NSArray* insertedObjects;

// deletedIndexes and insertedIndexes are the indexes that must be deleted from the oldArray, 
// and then inserted to form the newArray. These are useful for tableview animation.

@property (nonatomic, copy) NSIndexSet* deletedIndexes;
@property (nonatomic, copy) NSIndexSet* insertedIndexes;

// combinedDeletedIndexes and combinedInsertedIndexes are indexes to the combinedArray,
// used to display which elements in combinedArray were inserted or deleted.

@property (nonatomic, copy) NSIndexSet* combinedDeletedIndexes;
@property (nonatomic, copy) NSIndexSet* combinedInsertedIndexes;

@end



@interface NSArray (JBDiff)

-(JBDiffResult*)diffWithArray:(NSArray*)newArray;

@end
