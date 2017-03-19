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

- (void)testDealSql {
    NSString *sql = @"create table if not exists t_student(id integer primary key autoincrement, name text, age integer, score real default 60)";
//     NSString *sql = @"insert into t_student(name, age) values ('lucy', 18)";
//    NSString *sql = @"UPDATE t_student SET name = 'Fred' WHERE age = 15";
    BOOL result = [XSqliteTool dealSql:sql uid:nil];
    XCTAssertTrue(result);
    
}

- (void)testQuerySql {
    
    NSString *sql = @"select * from t_student";
    NSArray *arr = [XSqliteTool querySql:sql uid:nil];
    NSLog(@"%@", arr);
}

- (void)testDealSqls {
    
    Class cls = NSClassFromString(@"XStudent");
    
    BOOL result = [XSqliteTool dealSqls:[XSqliteModelTool udpateSqls:cls uid:nil] uid:nil];
    NSLog(@"%d", result);
}
@end
