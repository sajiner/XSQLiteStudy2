//
//  XSqliteModelToolTest.m
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XSqliteModelTool.h"
#import "XStudent.h"

@interface XSqliteModelToolTest : XCTestCase

@end

@implementation XSqliteModelToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
//    BOOL result = [XSqliteModelTool createTable:[XStudent class] uid:nil];
    BOOL result = [XSqliteModelTool isTableRequiredUpdate:[XStudent class]  uid:nil];
    NSLog(@"%d", result);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
