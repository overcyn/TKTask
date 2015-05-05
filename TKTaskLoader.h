#import "TKTask.h"
@protocol TKTaskLoaderDelegate;

@interface TKTaskLoader : NSObject
- (id)initWithTask:(TKTask)task delegate:(id<TKTaskLoaderDelegate>)delegate;
@property (nonatomic, strong) TKTaskOutput *output;
@property (nonatomic) NSInteger tag;
@end

@protocol TKTaskLoaderDelegate <NSObject>
- (void)loaderDidLoad:(TKTaskLoader *)loader;
@end
