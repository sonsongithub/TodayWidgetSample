//
//  TodayViewController.m
//  WidgetDailyTest
//
//  Created by sonson on 2014/06/19.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding> {
	IBOutlet UILabel *label1;
	IBOutlet UILabel *label2;
	IBOutlet UILabel *label3;
	IBOutlet UILabel *label4;
}
@end

@implementation TodayViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (IBAction)hoge:(id)sender {
	NSLog(@"hoge:");
}

- (void)viewDidLoad {
	NSLog(@"viewDidLoad");
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor redColor];
	
    // Do any additional setup after loading the view from its nib.
	self.preferredContentSize = CGSizeMake(280, 129);
	[self updateLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)path {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *path = [NSString stringWithFormat:@"%@/test.txt", documentsDirectory];
	NSString *FolderPath = [path stringByDeletingLastPathComponent];
	
	[[NSFileManager defaultManager] createDirectoryAtPath:FolderPath withIntermediateDirectories:YES attributes:nil error:nil];

	return path;
}

- (void)updateLabel {
	NSData *data = [NSData dataWithContentsOfFile:[self path]];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSError *error = nil;
	NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"http://rdsig.yahoo.co.jp/(.+?)\">(.+?)</a>"
																			options:0
																			  error:&error];
	NSArray *results = [regexp matchesInString:string options:0 range:NSMakeRange(0, string.length)];
	
	if ([results count] > 3) {
		NSRange range;
		range = [results[0] rangeAtIndex:2];
		label1.text = [string substringWithRange:range];
		range = [results[1] rangeAtIndex:2];
		label2.text = [string substringWithRange:range];
		range = [results[2] rangeAtIndex:2];
		label3.text = [string substringWithRange:range];
		range = [results[3] rangeAtIndex:2];
		label4.text = [string substringWithRange:range];
	}
}

- (void)updateContentWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
	NSURLRequest  *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.yahoo.co.jp"]];
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[[NSOperationQueue alloc] init]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
							   [data writeToFile:[self path] atomically:NO];
							   [self updateLabel];
							   if (completionHandler) {
								   completionHandler(NCUpdateResultNewData);
							   }
						   }];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"viewWillAppear:");
	[super viewWillAppear:animated];
	[self updateContentWithCompletionHandler:nil];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
	NSLog(@"widgetMarginInsetsForProposedMarginInsets:");
	NSLog(@"%f,%f,%f,%f", defaultMarginInsets.bottom, defaultMarginInsets.left, defaultMarginInsets.top, defaultMarginInsets.right);
	return UIEdgeInsetsMake(0, 0, 0, 0);
	return defaultMarginInsets;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
	NSLog(@"widgetPerformUpdateWithCompletionHandler:");
    // Perform any setup necessary in order to update the view.
	[self updateContentWithCompletionHandler:completionHandler];
}

- (void)dealloc {
	NSLog(@"dealloc:");
}

@end
