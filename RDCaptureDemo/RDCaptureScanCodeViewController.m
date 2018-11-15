//
//  RDCaptureScanCodeViewController.m
//  RDCaptureDemo
//
//  Created by Rain Day on 2018/11/14.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import "RDCaptureScanCodeViewController.h"
#import "AVFoundation/AVFoundation.h"

@interface RDCaptureScanCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) IBOutlet UIView *backgroundView;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@end

@implementation RDCaptureScanCodeViewController

- (void)dealloc {
    [self.captureSession stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configureCaptureSession];
}

- (void)configureCaptureSession {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];

    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];

    if ([captureSession canAddInput:videoDeviceInput]) {
        [captureSession addInput:videoDeviceInput];
    }

    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([captureSession canAddOutput:metadataOutput]) {
        [captureSession addOutput:metadataOutput];
    }
    NSArray *availableMetadataObjectTypes = metadataOutput.availableMetadataObjectTypes;
    metadataOutput.metadataObjectTypes = availableMetadataObjectTypes;

    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer below:self.backgroundView.layer];

    [captureSession startRunning];

    self.captureSession = captureSession;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0 && metadataObjects != nil) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects lastObject];
        NSString *result = metadataObject.stringValue;

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:result message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];

        [self.captureSession stopRunning];
    }
}

#pragma mark - IBAction
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
