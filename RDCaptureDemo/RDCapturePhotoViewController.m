//
//  RDCapturePhotoViewController.m
//  RDCaptureDemo
//
//  Created by Rain Day on 2018/11/14.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import "RDCapturePhotoViewController.h"
#import "AVFoundation/AVFoundation.h"

@interface RDCapturePhotoViewController () <AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) IBOutlet UIView *backgroundView;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@end

@implementation RDCapturePhotoViewController

- (void)dealloc {
    [self.captureSession stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureCaptureSession];

//    [self configureCaptureSessionWithStillImageOutput];
}

- (void)configureCaptureSession {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        [captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    AVCaptureDevice *photoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *photoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:photoDevice error:nil];
    if ([captureSession canAddInput:photoDeviceInput]) {
        [captureSession addInput:photoDeviceInput];
    }
    AVCapturePhotoOutput *photoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([captureSession canAddOutput:photoOutput]) {
        [captureSession addOutput:photoOutput];
    }

    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer below:self.backgroundView.layer];

    [captureSession startRunning];

    self.captureSession = captureSession;
    self.photoOutput = photoOutput;
}

- (void)configureCaptureSessionWithStillImageOutput {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        [captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    AVCaptureDevice *photoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *photoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:photoDevice error:nil];
    if ([captureSession canAddInput:photoDeviceInput]) {
        [captureSession addInput:photoDeviceInput];
    }
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([captureSession canAddOutput:stillImageOutput]) {
        [captureSession addOutput:stillImageOutput];
    }

    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer below:self.backgroundView.layer];

    [captureSession startRunning];

    self.captureSession = captureSession;
    self.stillImageOutput = stillImageOutput;
}

#pragma mark - AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    NSData *imageData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:imageData];
    NSLog(@"%@", image);
}

#pragma mark - IBAction
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takePhoto:(id)sender {
    if (self.photoOutput) {
        [self.photoOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
    } else {
        AVCaptureConnection *captureConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            NSLog(@"%@", image);
        }];
    }
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
