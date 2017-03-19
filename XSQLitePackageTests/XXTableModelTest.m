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

/**
 获取排好序的表名
 */
- (void)testTableSortedNames {
    Class cls = NSClassFromString(@"XStudent");
    NSArray *sortedArray = [XTableModel tableSortedNames:cls uid:nil];
    NSLog(@"%@", sortedArray);
}

@end
