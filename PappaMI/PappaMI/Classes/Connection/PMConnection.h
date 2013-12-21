#import <Foundation/Foundation.h>

@interface PMConnection : NSObject

- (void)getAPIhost:(void(^)(BOOL veespoHost))block;
- (void)loginUser:(NSDictionary *)userData success:(void(^)(id responseData))success failure:(void(^)(id responseData))failure;
- (void)getGuestData:(void(^)(id responseData))success failure:(void(^)(id responseData))failure;

@end
