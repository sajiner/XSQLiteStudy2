//
//  XModelTool.h
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XModelTool : NSObject

/**
 获取表名

 @param cls 类名
 @return 表名
 */
+ (NSString *)tableName: (Class)cls;

/**
 获取成员变量和成员变量的类型 字典

 @param cls 类名
 @return 字典
 */
+ (NSDictionary *)classIvarNameAndTypeDict: (Class)cls;

/**
 获取类的成员变量和成员变量的类型映射成sqlite的类型 字典

 @param cls 类名
 @return 字典
 */
+ (NSDictionary *)classIvarNameAndSqliteTypeDict: (Class)cls;

/**
 获取表的字段及类型

 @param cls 类名
 @return 表的字段及类型
 */
+ (NSString *)columnNameAndTypeStr: (Class)cls;

@end
