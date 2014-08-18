//
//  JMTest3GModel.h
//  Caibao
//
//  Created by Looping on 14/7/30.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "JSONModel.h"

@protocol JMTest3GModel

@end

@interface JMTest3GModel : JSONModel

@property (nonatomic) NSString <Index> *name;
@property (nonatomic)NSInteger age;

@end
