//
//  XStudent.h
//  XSQLitePackage
//
//  Created by 张鑫 on 2017/3/17.
//  Copyright © 2017年 sajiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XModelProtocol.h"

@interface XStudent : NSObject<XModelProtocol> {
    int b;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int stuNum;
@property (nonatomic, assign) double score;
@property (nonatomic, assign) double score2;

@end
