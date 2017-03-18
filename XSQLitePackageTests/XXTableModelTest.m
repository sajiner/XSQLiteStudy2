//
//  XXTableModelTest.m
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/18.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XTableModel.h"

@interface XXTableModelTest : XCTestCase

@end

@implementation XXTableModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    Class cls = NSClassFromString(@"XStudent");
    NSArray *sortedArray = [XTableModel tableSortedNames:cls uid:nil];
    NSLog(@"%@", sortedArray);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
