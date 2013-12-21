#import "PMConnection.h"
#import "AFNetworking.h"

static NSString *pappamiconfing = @"http://api.pappa-mi.it/api/config";

@implementation PMConnection

- (void)getAPIhost:(void(^)(BOOL veespoHost))block
{
    NSURL *url = [NSURL URLWithString:pappamiconfing];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *host = [NSDictionary dictionaryWithDictionary:JSON];
        [[NSUserDefaults standardUserDefaults] setObject:host[@"apihost"] forKey:@"apihost"];
        if ([host[@"veespoproduction"] isEqualToString:@"NO"])
            block(YES);
        else if ([host[@"veespoproduction"] isEqualToString:@"YES"])
            block(NO);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        block(NO);
    }];
    [operation start];
}

- (void)loginUser:(NSDictionary *)userData success:(void(^)(id responseData))success failure:(void(^)(id responseData))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]]];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
#ifdef DEVUSER
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"darthpelo@gmail.com", @"email",
                            @"password", @"password",
                            nil];
#else
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:userData];
#endif
    
    [httpClient postPath:@"/auth/password" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSURL *url = [NSURL URLWithString:
                      [NSString stringWithFormat:@"http://%@/api/user/current", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]]];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            success(JSON);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            failure(error.localizedDescription);
        }];
        
        [jsonRequest start];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

- (void)getGuestData:(void(^)(id responseData))success failure:(void(^)(id responseData))failure
{
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://%@/api/user/current", [[NSUserDefaults standardUserDefaults] objectForKey:@"apihost"]]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(error.localizedDescription);
    }];
    
    [jsonRequest start];
}

@end
