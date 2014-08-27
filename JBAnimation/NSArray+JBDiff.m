//
//  NSArray+JBDiff.m
//  Tyche
//
//  Created by Joel Bernstein on 3/19/10.
//



#import "NSArray+JBDiff.h"



@implementation JBDiffResult

@end



@implementation NSArray (JBDiff)

// Bottom-Up Iterative LCS algorithm from http://www.ics.uci.edu/~eppstein/161/960229.html

-(JBDiffResult*)diffWithArray:(NSArray*)secondArray;
{
//    NSLog(@"self.count = %i, secondArray.count = %i", self.count, secondArray.count);

    NSUInteger width = secondArray.count + 1;
    NSUInteger height = self.count + 1;
    
    NSUInteger* lengthArray = calloc(width * height, sizeof(NSUInteger));
    
    for(NSInteger firstArrayIndex = self.count; firstArrayIndex >= 0; firstArrayIndex--)
    {    
        for(NSInteger secondArrayIndex = secondArray.count; secondArrayIndex >= 0; secondArrayIndex--)
        {
            if(firstArrayIndex == (NSInteger)self.count || secondArrayIndex == (NSInteger)secondArray.count)
            {
                lengthArray[firstArrayIndex * width + secondArrayIndex] = 0;
            }
            else if([self[firstArrayIndex] isEqual:secondArray[secondArrayIndex]]) 
            {
                lengthArray[firstArrayIndex * width + secondArrayIndex] = 1 + lengthArray[(firstArrayIndex + 1) * width + (secondArrayIndex + 1)];
            }
            else
            {
                lengthArray[firstArrayIndex * width + secondArrayIndex] = MAX(lengthArray[(firstArrayIndex + 1) * width + secondArrayIndex], lengthArray[firstArrayIndex * width + (secondArrayIndex + 1)]);
            }
        }
    }
    
    NSMutableArray*    lcsArray                = [NSMutableArray array];
    NSMutableArray*    combinedArray           = [NSMutableArray array];
    NSMutableArray*    deletedObjects          = [NSMutableArray array];
    NSMutableArray*    insertedObjects         = [NSMutableArray array]; 
    NSMutableIndexSet* deletedIndexes          = [NSMutableIndexSet indexSet];
    NSMutableIndexSet* insertedIndexes         = [NSMutableIndexSet indexSet]; 
    NSMutableIndexSet* combinedDeletedIndexes  = [NSMutableIndexSet indexSet];
    NSMutableIndexSet* combinedInsertedIndexes = [NSMutableIndexSet indexSet]; 
    
    NSUInteger firstArrayIndex = 0;
    NSUInteger secondArrayIndex = 0;
    NSUInteger combinedArrayIndex = 0;
    
    while(firstArrayIndex < self.count && secondArrayIndex < secondArray.count)
    {
        if([self[firstArrayIndex] isEqual:secondArray[secondArrayIndex]])
        {
            [lcsArray      addObject:self[firstArrayIndex]];
            [combinedArray addObject:self[firstArrayIndex]];
            
            firstArrayIndex++; 
            secondArrayIndex++;
            combinedArrayIndex++;
        }
        else if(lengthArray[(firstArrayIndex + 1) * width + secondArrayIndex] >= lengthArray[firstArrayIndex * width + (secondArrayIndex + 1)])
        {
            [combinedArray          addObject:self[firstArrayIndex]];
            [deletedObjects         addObject:self[firstArrayIndex]];
            [deletedIndexes         addIndex:firstArrayIndex];
            [combinedDeletedIndexes addIndex:combinedArrayIndex];
            
            firstArrayIndex++;
            combinedArrayIndex++;
        }
        else
        {
            [combinedArray           addObject:secondArray[secondArrayIndex]];
            [insertedObjects         addObject:secondArray[secondArrayIndex]];
            [insertedIndexes         addIndex:secondArrayIndex];
            [combinedInsertedIndexes addIndex:combinedArrayIndex];
            
            secondArrayIndex++;
            combinedArrayIndex++;
        }
    }

    free(lengthArray);
    
    while(firstArrayIndex < self.count) 
    {
        [combinedArray          addObject:self[firstArrayIndex]];
        [deletedObjects         addObject:self[firstArrayIndex]];
        [deletedIndexes         addIndex:firstArrayIndex];
        [combinedDeletedIndexes addIndex:combinedArrayIndex];
        
        firstArrayIndex++;
        combinedArrayIndex++;
    }
    
    while(secondArrayIndex < secondArray.count) 
    {
        [combinedArray           addObject:secondArray[secondArrayIndex]];
        [insertedObjects         addObject:secondArray[secondArrayIndex]];
        [insertedIndexes         addIndex:secondArrayIndex];
        [combinedInsertedIndexes addIndex:combinedArrayIndex];
        
        secondArrayIndex++;
        combinedArrayIndex++;
    }
    
    JBDiffResult* result = [[JBDiffResult alloc] init];
    
    result.firstArray              = [self copy];
    result.secondArray             = [secondArray copy];
    result.lcsArray                = lcsArray;               
    result.combinedArray           = combinedArray;          
    result.deletedObjects          = deletedObjects;         
    result.insertedObjects         = insertedObjects;        
    result.deletedIndexes          = deletedIndexes;         
    result.insertedIndexes         = insertedIndexes;        
    result.combinedDeletedIndexes  = combinedDeletedIndexes; 
    result.combinedInsertedIndexes = combinedInsertedIndexes;
    
    return result;
}

@end
