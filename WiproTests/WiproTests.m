//
//  WiproTests.m
//  wipro
//
//  Created by Jigar Thakkar on 18/2/18.
//  Copyright © 2017 Jigar Thakkar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface WiproTests : XCTestCase

@end

@implementation WiproTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        ViewController *obj_factcontroller = [[ViewController alloc] init];
        [obj_factcontroller fetchDataFromJSONFile];
    }];
}

@end
