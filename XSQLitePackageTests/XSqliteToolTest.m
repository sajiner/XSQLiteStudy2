//
//  XSqliteToolTest.m
//  XSQLitePackage
//
//  Created by sajiner on 2017/3/9.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XSqliteTool.h"
#import "XSqliteModelTool.h"

@interface XSqliteToolTest : XCTestCase

@end

@implementation XSqliteToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
//    NSString *sql = @"create table if not exists t_student(id integer primary key autoincrement, name text, age integer, score real default 60)";
//     NSString *sql = @"insert into t_student(name, age) values ('lucy', 18)";
//    NSString *sql = @"UPDATE t_student SET name = 'Fred' WHERE age = 15";
    Class cls = NSClassFromString(@"XStudent");
    
    BOOL result = [XSqliteTool dealSqls:[XSqliteModelTool udpateSqls:cls uid:nil] uid:nil];
    NSLog(@"%d", result);
}

- (void)testQueryExample {
    NSString *sql = @"select * from t_student";
    
    NSArray *arr = [XSqliteTool querySql:sql uid:nil];
    NSLog(@"%@", arr);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
