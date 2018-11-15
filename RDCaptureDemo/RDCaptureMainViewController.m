//
//  RDCaptureMainViewController.m
//  RDCaptureDemo
//
//  Created by Rain Day on 2018/11/13.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import "RDCaptureMainViewController.h"
#import "RDCaptureVideoViewController.h"
#import "RDCapturePhotoViewController.h"
#import "RDCaptureScanCodeViewController.h"

@interface RDCaptureMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation RDCaptureMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"自定义相机";

    self.dataSource = @[@"视频", @"拍照", @"扫码"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RDCaptureVideoViewController *viewController = [[UIStoryboard storyboardWithName:@"RDCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"RDCaptureVideoViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        RDCapturePhotoViewController *viewController = [[UIStoryboard storyboardWithName:@"RDCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"RDCapturePhotoViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        RDCaptureScanCodeViewController *viewController = [[UIStoryboard storyboardWithName:@"RDCapture" bundle:nil] instantiateViewControllerWithIdentifier:@"RDCaptureScanCodeViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

@end
