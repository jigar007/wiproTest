//
//  ViewController.m
//  wipro
//
//  Created by Jigar Thakkar on 18/2/18.
//  Copyright © 2017 Jigar Thakkar. All rights reserved.
//

#import "ViewController.h"
#import "RowData.h"

@interface ViewController()
@property(strong, nonatomic) NSURLConnection *connection;
@property(strong, nonatomic) NSMutableData *data;
@property(strong, nonatomic) NSURLResponse *response;
@end

@implementation ViewController
@synthesize arrFacts = _arrFacts;
@synthesize connection = _connection;
@synthesize data = _data;
@synthesize response = _response;
@synthesize delegate = _delegate;

- (id)init{
    if (self == [super init]) {
        _arrFacts = [NSArray array];
    }
    return self;
}

- (void)setArrFacts:(NSArray *)arrFacts {
    _arrFacts = arrFacts;
}

-(void) dealloc {
    if (_arrFacts) {
        _arrFacts = nil;
    }
}

- (void)resetProperties {
    _data = nil;

    _response = nil;
    if (_connection) {
        [_connection cancel];

        [_connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _connection = nil;
    }
}


- (void)fetchDataFromJSONFile {

    NSCharacterSet *expectedCharSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *urlString = [@"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
                           stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet];
    
    //-- Preparing a url from predefined link string.
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    //-- A url request to fetch data in asynchronous manner.
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    //-- To reset the web-service related values
    [self resetProperties];
    
    //-- To initiate the connection object.
    _connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    //-- Schedule the run loop for connection
    [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //-- Start after initiation
    [_connection start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //-- To reset the web-service related values
    [self resetProperties];
    [_delegate connectionDidReceiveFailure: [error localizedDescription]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //-- Create mutable data once the response received.
    if (!_data) {
        _data = [[NSMutableData alloc] init];
    }
    //-- Cache the response object for later use in ConnectionDidFinishLoading.
    _response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //-- Append the data received from server.
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_response && ((NSHTTPURLResponse *)_response).statusCode == 200) {
        //-- As becuase downaloded data contains special characters first of all we have to conver it into String format.
        NSString *latinString = [[NSString alloc] initWithData:_data encoding:NSISOLatin1StringEncoding];
        
        //-- Now create a data from String content with the help of UTF8Encoding
        NSData *jsonData = [latinString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (latinString != nil && jsonData != nil) {
            NSError *error = nil;
            //-- Fetch key-value pair object from a JSON data
            NSDictionary *dictionaryInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            //-- Display an error if you get at the time of converting a JSON data to an object.
            if (error != nil) {                
                //-- To reset the web-service related values
                [self resetProperties];
                [_delegate connectionDidReceiveFailure: [NSString stringWithFormat:@"JSON Parsing Error due to : %@", [error localizedDescription]]];
            } else {
                NSLog(@"%@", [dictionaryInfo description]);
                if (_arrFacts) {
                    _arrFacts = nil;
                }
                NSArray *arrTmp = [NSArray arrayWithArray:dictionaryInfo[@"rows"]];
                [arrTmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RowData *obj_fact = [[RowData alloc]initObjectWithDictionary:obj];
                    if (!_arrFacts) {
                        _arrFacts = [[NSArray alloc] initWithObjects:obj_fact, nil];
                    } else {
                        _arrFacts = [_arrFacts arrayByAddingObject:obj_fact];
                    }
                }];
                [_delegate connectionDidFinishLoading:dictionaryInfo];

                [self resetProperties];
            }
        } else {
            [self resetProperties];
            [_delegate connectionDidReceiveFailure:@"An error while manipulating data or string conents."];
        }
    } else {
        [self resetProperties];
        if (_data) {
            NSString *errorMessage = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
            [_delegate connectionDidReceiveFailure:errorMessage];
        } else {
            [_delegate connectionDidReceiveFailure:@"No data available to download or an error while downloading a data."];
        }
    }
}

@end
