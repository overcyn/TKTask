#import "TKTaskBatchLoader.h"

@implementation TKTaskBatchLoader {
    NSMutableDictionary *_outputByIndex;
    NSIndexSet *_indexes;
    NSMutableIndexSet *_indexesToLoad;
    __weak id<TKTaskBatchLoaderDelegate> _delegate;
    NSInteger _runningTasks;
}

- (id)initWithIndexesToLoad:(NSIndexSet *)indexes delegate:(id<TKTaskBatchLoaderDelegate>)delegate {
    if ((self = [super init])) {
        _delegate = delegate;
        _indexes = indexes;
        _indexesToLoad = [indexes mutableCopy];
        _outputByIndex = [[NSMutableDictionary alloc] init];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _load];
        });
    }
    return self;
}

- (void)updateForVisibleIndexes:(NSIndexSet *)visible {
    // no-op
}

- (TKTaskOutput *)outputAtIndex:(NSInteger)index {
    return _outputByIndex[@(index)];
}

#pragma mark - Internal

- (void)_load {
    __weak typeof(self) weakSelf = self;
    TKTaskContext *context = [[TKTaskContext alloc] init];
    
    NSInteger index = [_indexesToLoad firstIndex];
    while (index != NSNotFound && _runningTasks < 5) {
        TKTask task = [_delegate taskForLoader:self atIndex:index];
        if (task) {
            _runningTasks += 1;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                TKTaskOutput *output = task(context);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf _taskDidComplete:output atIndex:index];
                });
            });
        }
        [_indexesToLoad removeIndex:index];
        index = [_indexesToLoad firstIndex];
    }
}

- (void)_taskDidComplete:(TKTaskOutput *)output atIndex:(NSInteger)index {
    [_outputByIndex setObject:output forKey:@(index)];
    [_delegate loader:self didLoadIndex:index];
    _runningTasks -= 1;
    [self _load];
}

@end
