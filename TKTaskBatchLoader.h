#import "TKTask.h"
@class TKTaskOutput;
@protocol TKTaskBatchLoaderDelegate;

@interface TKTaskBatchLoader : NSObject
- (id)initWithIndexesToLoad:(NSIndexSet *)indexes delegate:(id<TKTaskBatchLoaderDelegate>)delegate;
- (void)updateForVisibleIndexes:(NSIndexSet *)visible;
- (TKTaskOutput *)outputAtIndex:(NSInteger)index;
@end

@protocol TKTaskBatchLoaderDelegate <NSObject>
- (void)loader:(TKTaskBatchLoader *)loader didLoadIndex:(NSInteger)index;
- (TKTask)taskForLoader:(TKTaskBatchLoader *)loader atIndex:(NSInteger)index;
@end
