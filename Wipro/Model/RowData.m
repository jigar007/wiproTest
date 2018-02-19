//
//  RowData.m
//  wipro
//
//  Created by Jigar Thakkar on 18/2/18.
//  Copyright © 2018 Jigar Thakkar. All rights reserved.
//

#import "RowData.h"

@implementation RowData
@synthesize title = _title;
@synthesize descriptions = _descriptions;
@synthesize imageHref = _imageHref;

- (id)initObjectWithDictionary:(NSDictionary *)dictionaryInfo {
    if (self == [super init]) {
        _title = dictionaryInfo[@"title"];
        _descriptions = dictionaryInfo[@"description"];
        _imageHref = dictionaryInfo[@"imageHref"];
    }
    return self;
}

- (void)dealloc {
    _title = nil;
    _descriptions = nil;
    _imageHref = nil;
}
@end
