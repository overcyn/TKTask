#import <Foundation/Foundation.h>

// Doesn't really do anything at the moment
@interface TKTaskContext : NSObject
@end

@interface TKTaskOutput : NSObject
+ (instancetype)outputWithResult:(id)result;
+ (instancetype)outputWithError:(id)error;
@property (nonatomic, readonly) id result;
@property (nonatomic, readonly) NSError *error;
@end

typedef TKTaskOutput *(^TKTask)(TKTaskContext *info);

TKTaskOutput *TKRunTaskSync(TKTask task);

#import "TKURLTask.h"
#import "TKTaskLoader.h"
#import "TKTaskBatchLoader.h"
