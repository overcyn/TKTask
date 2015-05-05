#import "TKTaskLoader.h"

@implementation TKTaskLoader {
    TKTaskOutput *_output;
    __weak id<TKTaskLoaderDelegate> _delegate;
    TKTask _task;
    NSInteger _tag;
}

- (id)initWithDelegate:(id<TKTaskLoaderDelegate>)delegate {
    return [self initWithTask:nil delegate:delegate];
}

- (id)initWithTask:(TKTask)task delegate:(id<TKTaskLoaderDelegate>)delegate {
    if ((self = [super init])) {
        _delegate = delegate;
        _task = [task copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _load];
        });
    }
    return self;
}

#pragma mark - API

@synthesize output = _output;
@synthesize tag = _tag;

#pragma mark - Internal

- (void)_load {
    TKTask task = _task;
    TKTaskContext *context = [[TKTaskContext alloc] init];
    __weak typeof(self) weakSelf = self;
    if (task) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            TKTaskOutput *output = task(context);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf _taskDidComplete:output];
            });
        });
    }
}

- (void)_taskDidComplete:(TKTaskOutput *)output {
    _output = output;
    [_delegate loaderDidLoad:self];
    if ([_output error]) {
//        MRLogf(@"Task finished with error. %@", [_output error]);
    }
}

@end
