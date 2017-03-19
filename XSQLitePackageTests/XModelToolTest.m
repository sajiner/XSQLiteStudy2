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

/**
  获取表名
 */
- (void)testGetTableName {
    NSString *tableName = [XModelTool tableName:[XStudent class]];
    NSLog(@"%@", tableName);
}

/**
 获取成员变量和成员变量的类型 字典
 */
- (void)testGetIvarNameAndTypeDict {
    NSDictionary *dict = [XModelTool classIvarNameAndTypeDict:[XStudent class]];
    NSLog(@"%@", dict);
}

/**
 获取类的成员变量和成员变量的类型映射成sqlite的类型 字典
 */
- (void)testIvarNameAndSqliteTypeDict {
    NSDictionary *dict = [XModelTool classIvarNameAndSqliteTypeDict:[XStudent class]];
    NSLog(@"%@", dict);
}

/**
  获取表的字段及类型
 */
- (void)testGetColumnNameAndTypeStr {
    NSDictionary *dict = [XModelTool classIvarNameAndSqliteTypeDict:[XStudent class]];
    NSLog(@"%@", dict);
}

/**
 所有排好序的表的字段
 */
- (void)testGetTableSortedIvarNames {
    NSArray *array = [XModelTool tableSortedIvarNames:[XStudent class]];
    NSLog(@"%@", array);
}

@end
