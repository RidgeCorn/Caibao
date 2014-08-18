//
//  MTTestsModel.m
//  Caibao
//
//  Created by Looping on 14/8/5.
//  Copyright (c) 2014 RidgeCorn. All rights reserved.
//

#import "MTTestsModel.h"
#import "Caibao.h"
#import <Mantle.h>

@implementation MTTestsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    return self;
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    NSValueTransformer *valueTransformer;
    if ([key isEqualToString:@"test"]) {
        valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MTTestModel class]];
    } else if ([key isEqualToString:@"test3g"]) {
        valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MTTest3GModel class]];
    } else if ([key isEqualToString:@"test3gs"]) {
        valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MTTest3GSModel class]];
    } else if ([key isEqualToString:@"test4"]) {
        valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MTTest4Model class]];;
    } else if ([key isEqualToString:@"test4s"]) {
        valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MTTest4SModel class]];
    } else if ([key isEqualToString:@"test5"]) {
        valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MTTest5Model class]];
    } else if ([key isEqualToString:@"test5s_5c"]) {
        valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MTTest5S_5CModel class]];
    }
        
    return valueTransformer;
}

- (instancetype)init {
    if (self = [super init]) {
        _name = NSStringFromClass([self class]);
        _age = 0;
        
        _test = [@[] mutableCopy];
        
        _test3g = [@[] mutableCopy];
        
        _test3gs = [@[] mutableCopy];
        
        _test4 = [@[] mutableCopy];
        
        _test4s = [@[] mutableCopy];
        
        _test5 = [@[] mutableCopy];
        
        _test5s_5c = [@[] mutableCopy];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self cb_initWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self cb_encodeWithCoder:aCoder];
}

@end
