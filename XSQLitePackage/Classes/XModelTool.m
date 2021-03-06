//
//  XModelTool.m
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import "XModelTool.h"
#import <objc/runtime.h>
#import "XModelProtocol.h"

@implementation XModelTool

+ (NSString *)columnNameAndTypeStr:(Class)cls {
    NSDictionary *nameTypeDict = [self classIvarNameAndSqliteTypeDict:cls];
    NSMutableArray *result = [NSMutableArray array];
    [nameTypeDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        [result addObject:[NSString stringWithFormat:@"%@ %@", key, obj]];
    }];
    return [result componentsJoinedByString:@","];
}

+ (NSDictionary *)classIvarNameAndSqliteTypeDict:(Class)cls {
    NSDictionary *typeDict = [self ocTypeToSqlType];
    
    NSMutableDictionary *dic = [[self classIvarNameAndTypeDict:cls] mutableCopy];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        dic[key] = typeDict[obj];
    }];
    return dic;
}

+ (NSDictionary *)classIvarNameAndTypeDict: (Class)cls {
    unsigned int outCount = 0;
    Ivar *ivarList = class_copyIvarList(cls, &outCount);
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([ivarName hasPrefix:@"_"]) {
            ivarName = [ivarName substringFromIndex:1];
        }
        
        NSArray *ignoreNames = nil;
        if ([cls respondsToSelector:@selector(ignoreColumnNames)]) {
            ignoreNames = [cls ignoreColumnNames];
        }
        if ([ignoreNames containsObject:ivarName]) {
            continue;
        }
       
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        [dictM setValue:type forKey:ivarName];
    }
    return dictM;
}

+ (NSString *)tableName:(Class)cls {
    return NSStringFromClass(cls);
}

+ (NSString *)tempTableName:(Class)cls {
    return [NSString stringWithFormat:@"%@_temp", [self tableName:cls]];
}

+ (NSArray *)tableSortedIvarNames:(Class)cls {
    NSDictionary *modelDict = [self classIvarNameAndSqliteTypeDict:cls];
    NSArray *modelNames = modelDict.allKeys;
    modelNames = [modelNames sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *name in modelNames) {
        [result addObject:[name lowercaseString]];
    }
    return result;
}

#pragma mark - 私有方法
+ (NSDictionary *)ocTypeToSqlType {
    return @{
             @"d" : @"real",  // double
             @"f" : @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
}

@end
