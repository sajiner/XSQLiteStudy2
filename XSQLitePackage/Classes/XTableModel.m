//
//  XTableModel.m
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/18.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import "XTableModel.h"
#import "XModelTool.h"
#import "XSqliteTool.h"

@implementation XTableModel

+ (NSArray *)tableSortedNames:(Class)cls uid:(NSString *)uid {
    NSString *tableName = [XModelTool tableName:cls];
    NSString *querySqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    NSDictionary *queryDict = [XSqliteTool querySql:querySqlStr uid:uid].firstObject;
    NSString *createSqlStr = queryDict[@"sql"];
    // "CREATE TABLE XStudent(age integer,stuNum integer,score real,name text, primary key(stuNum))"
    
    NSString *typeAndNames = [[createSqlStr componentsSeparatedByString:@"("][1] lowercaseString];
    // age integer,stuNum integer,score real,name text, primary key
    
    NSArray *results = [typeAndNames componentsSeparatedByString:@","];
    NSMutableArray *names = [NSMutableArray array];
    for (NSString *typeName in results) {
        if ([typeName containsString:@"primary"]) {
            continue;
        }
        NSString *name = [typeName componentsSeparatedByString:@" "].firstObject;
        [names addObject:name];
    }
    [names sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return names;
}

@end
