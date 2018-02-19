//
//
//  RowData.h
//  wipro
//
//  Created by Jigar Thakkar on 18/2/18.
//  Copyright © 2018 Jigar Thakkar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RowData : NSObject
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *descriptions;
@property(copy, nonatomic) NSString *imageHref;
- (id)initObjectWithDictionary:(NSDictionary *)dictionaryInfo;
@end
