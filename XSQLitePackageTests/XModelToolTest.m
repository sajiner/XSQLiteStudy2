//
//  XModelToolTest.m
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XStudent.h"
#import "XModelTool.h"

@interface XModelToolTest : XCTestCase

@end

@implementation XModelToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
//    NSString *dict = [XModelTool columnNameAndTypeStr:[XStudent class]];
    NSArray *arr = [XModelTool tableSortedIvarNames:[XStudent class]];
    NSLog(@"%@", arr);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
