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

- (void)testCreateTable {
    BOOL result = [XSqliteModelTool createTable:[XStudent class] uid:nil];
    XCTAssertTrue(result);
}

- (void)testUpdateTable {
    BOOL result = [XSqliteModelTool isTableRequiredUpdate:[XStudent class] uid:nil];
    XCTAssertFalse(result);
}

- (void)testSuccessUpdateTable {
    BOOL result = [XSqliteModelTool isSuccessUpdateTable:[XStudent class] uid:nil];
    XCTAssertTrue(result);
}

@end
