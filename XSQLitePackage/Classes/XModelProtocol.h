//
//  XModelProtocol.h
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XModelProtocol <NSObject>

/**
 主键

 @return 主键
 */
+ (NSString *)primaryKey;

/**
 忽略的类的属性 数组

 @return 被忽略的数组
 */
+ (NSArray *)ignoreColumnNames;

@end
