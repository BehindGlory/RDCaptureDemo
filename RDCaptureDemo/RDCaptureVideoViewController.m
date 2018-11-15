//
//  RDCaptureVideoViewController.m
//  RDCaptureDemo
//
//  Created by Rain Day on 2018/11/13.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import "RDCaptureVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RDCaptureVideoViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, weak) IBOutlet UIView *backgroundView;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;

@end

@implementation RDCaptureVideoViewController

- (void)dealloc {
    [self.captureSession stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
//    [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

    dispatch_async(dispatch_get_main_queue(), ^{

    });
    [self configureCaptureSession];
}

- (void)configureCaptureSession {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];

    [captureSession beginConfiguration];

    if ([captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    if ([captureSession canAddInput:videoInput]) {
        [captureSession addInput:videoInput];
    }
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    if ([captureSession canAddInput:audioInput]) {
        [captureSession addInput:audioInput];
    }
    AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([captureSession canAddOutput:movieFileOutput]) {
        [captureSession addOutput:movieFileOutput];
    }
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer below:self.backgroundView.layer];

    [captureSession commitConfiguration];

    [captureSession startRunning];

    self.captureSession = captureSession;
    self.movieFileOutput = movieFileOutput;
}

- (void)startRecording {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pathName = [NSString stringWithFormat:@"%@/Video", documentPath] ;
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathName]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *outputPath = [NSString stringWithFormat:@"%@/%@.mov",pathName,[NSUUID UUID].UUIDString];
    NSURL *outputFileURL = [NSURL fileURLWithPath:outputPath];

    [self.movieFileOutput startRecordingToOutputFileURL:outputFileURL recordingDelegate:self];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.movieFileOutput stopRecording];
        [self.captureSession stopRunning];
    });
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(nullable NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"录制完成" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

}

#pragma mark - IBAction
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recordVideo:(id)sender {
    [self startRecording];
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
