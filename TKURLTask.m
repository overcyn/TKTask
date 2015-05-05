#import "TKURLTask.h"

TKTask TKURLTask(NSURL *url) {
    return ^(TKTaskContext *context) {
        return TKURLRequestTask([NSURLRequest requestWithURL:url])(context);
    };
}

TKTask TKURLRequestTask(NSURLRequest *urlRequest) {
    return ^(TKTaskContext *context) {
        __block NSData *data = nil;
        __block NSURLResponse *response = nil;
        __block NSError *error = nil;
        dispatch_semaphore_t s = dispatch_semaphore_create(0);
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
            data = d;
            response = r;
            error = e;
            dispatch_semaphore_signal(s);
        }];
        [task resume];
        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        
        if (error) {
            return [TKTaskOutput outputWithError:error];
        } else {
            return [TKTaskOutput outputWithResult:data];
        }
    };
}
