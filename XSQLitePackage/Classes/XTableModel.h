//
//  XTableModel.h
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/18.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTableModel : NSObject

/**
 获取排好序的表名

 @param cls 类名
 @param uid uid
 @return 排好序的表名
 */
+ (NSArray *)tableSortedNames: (Class)cls uid: (NSString *)uid;

/**
 判断表格是否存在

 @param cls 类名
 @param uid uid
 @return 存在与否
 */
+ (BOOL)isTableExists: (Class)cls uid: (NSString *)uid;

@end
