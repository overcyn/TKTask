#import "TKTask.h"

@interface TKTaskContext ()
@end

@implementation TKTaskContext
@end

@interface TKTaskOutput ()
@property (nonatomic, strong) id result;
@property (nonatomic, strong) NSError *error;
@end

@implementation TKTaskOutput
+ (instancetype)outputWithResult:(id)result {
    TKTaskOutput *output = [[self alloc] init];
    [output setResult:result];
    return output;
}
+ (instancetype)outputWithError:(id)error {
    NSParameterAssert(error != nil);
    TKTaskOutput *output = [[self alloc] init];
    [output setError:error];
    return output;
}
@end

TKTaskOutput *TKRunTaskSync(TKTask task) {
    TKTaskContext *context = [[TKTaskContext alloc] init];
    __block TKTaskOutput *output = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        output = task(context);
    });
    return output;
}
