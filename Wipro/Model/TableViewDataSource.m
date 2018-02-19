//
//  TableViewDataSource.m
//  wipro
//
//  Created by Jigar Thakkar on 18/2/18.
//  Copyright © 2018 Jigar Thakkar. All rights reserved.
//

#import "TableViewDataSource.h"
#import "NSString+Additions.h"
#import "RowData.h"

@interface TableViewDataSource()<UITableViewDataSource>
@end

@implementation TableViewDataSource
@synthesize viewController = _viewController;

// initialization of table view.
- (id)initTableView:(UITableView *)tableView withViewController:(ViewController *)controller {
    if (self == [super init]) {
        _viewController = controller;
        tableView.dataSource = self;
    }
    return self;
}

- (void)dealloc {
    _viewController = nil;
}

// cell for index path method for to show data in to each row.
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
            cell.detailTextLabel.font = [UIFont fontWithName:cell.detailTextLabel.font.familyName size:cell.detailTextLabel.font.pointSize + 8.0];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.familyName size:cell.textLabel.font.pointSize + 8.0];
        }
    }
    @try {
        if (_viewController.arrFacts.count > 0) {
            
            RowData *obj_rowData = [_viewController.arrFacts objectAtIndex:indexPath.row];
            
            if (![obj_rowData.title isEqual:[NSNull null]] && [[obj_rowData.title trim] length] > 0) {
                cell.textLabel.text = [obj_rowData.title trim];
            } else {
                cell.textLabel.text = @"";
            }
            
            if (![obj_rowData.descriptions isEqual:[NSNull null]] && [[obj_rowData.descriptions trim] length] > 0) {
                cell.detailTextLabel.text = [obj_rowData.descriptions trim];
            } else {
                cell.detailTextLabel.text = @"";
            }
            
            if (![obj_rowData.imageHref isEqual:[NSNull null]] && [[obj_rowData.imageHref trim] length] > 0) {
                NSURL *imageurl = [NSURL URLWithString:[obj_rowData.imageHref trim]];
                __unsafe_unretained __typeof(cell)weakCell = cell;
                
                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageurl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (!connectionError) {
                        UIImage *image = [[UIImage alloc] initWithData:data];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
                                weakCell.imageView.image = [self resizeImage:image scaledToSize:CGSizeMake(100.0, 100.0)];
                            } else {
                                weakCell.imageView.image = [self resizeImage:image scaledToSize:CGSizeMake(60.0, 60.0)];
                            }
                    
                            [cell setNeedsLayout];
                        });
                        
                         [weakCell layoutSubviews];
                         [weakCell setNeedsLayout];
                        // pass the img to your imageview
                    }else{
                        NSLog(@"%@",connectionError);
                    }
                }];
                
            } else {
                cell.imageView.image = nil;
            }
        } else {

            cell.detailTextLabel.text = @"Pull down to refresh";
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception %@", exception.reason);
    } @finally {
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_viewController.arrFacts.count > 0) {
        return _viewController.arrFacts.count;
    } else {
        return 1;
    }
}

// to make image resize so images with diff dimensions looks same.
- (UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  
    CGSize size = image.size;
    
    CGFloat widthRatio  = newSize.width  / image.size.width;
    CGFloat heightRatio = newSize.height / image.size.height;
    
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio);
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio);
    }
    
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
