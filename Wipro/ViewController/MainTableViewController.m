//
//  MainTableViewController.m
//  wipro
//
//  Created by Jigar Thakkar on 18/2/18.
//  Copyright © 2017 Jigar Thakkar. All rights reserved.
//

#import "MainTableViewController.h"
#import "AppDelegate.h"
#import "TableViewDataSource.h"
#import "ViewController.h"

@interface MainTableViewController ()
@property(strong, nonatomic) UIRefreshControl *refreshControler;
@property(strong, nonatomic) TableViewDataSource *tableviewDatasource;
@property(strong, nonatomic) ViewController *factController;
@end

@implementation MainTableViewController
@synthesize refreshControler = _refreshControler;
@synthesize factController = _factController;
@synthesize tableviewDatasource = _tableviewDatasource;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.tableView.allowsSelection = NO;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"] || [[UIDevice currentDevice].model isEqualToString:@"ipad"]) {
        self.tableView.estimatedRowHeight = 110.0;
    } else {
        self.tableView.estimatedRowHeight = 65.0;
    }
    self.tableView.tableFooterView = [UIView new];
    
    _refreshControler = [[UIRefreshControl alloc] init];
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = _refreshControler;
    } else {
        [self.tableView addSubview:_refreshControler];
    }
    [_refreshControler addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
    
    ViewController *obj_factController = [[ViewController alloc] init];
    obj_factController.delegate = (id)self;
    self.factController = obj_factController; 
    obj_factController = nil;
    
    _tableviewDatasource = [[TableViewDataSource alloc] initTableView:self.tableView withViewController:self.factController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullToRefresh:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) dealloc {
    _refreshControler = nil;
}

- (void)connectionDidReceiveFailure:(NSString *)error {
    self.title = @"";
    [((AppDelegate *)[[UIApplication sharedApplication]delegate]) displayAnAlertWith:@"Alert !!" andMessage:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshControler endRefreshing];
    });
}

- (void)connectionDidFinishLoading:(NSDictionary *)dictResponseInfo {
    self.title = dictResponseInfo[@"title"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [_refreshControler endRefreshing];
        if (self.factController.arrFacts != nil && self.factController.arrFacts.count > 0) {
            self.tableView.hidden = NO;
        } else {
            self.tableView.hidden = YES;
        }
        [self.tableView reloadData];
    });
}


- (IBAction)pullToRefresh:(id)sender {
    [_refreshControler beginRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
    [self.factController fetchDataFromJSONFile];
}

@end
