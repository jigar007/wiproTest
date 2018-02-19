//
//  AppDelegate.h
//  wipro
//
//  Created by Jigar Thakkar on 18/2/18.
//  Copyright © 2017 Jigar Thakkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

- (void)displayAnAlertWith:(NSString *)title andMessage:(NSString *)message;
@end

