//
//  PhotoViewController.m
//  Instagram
//
//  Created by Rucha Patki on 7/12/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PhotoViewController.h"
#import "ComposeViewController.h"

@interface PhotoViewController () <AVCapturePhotoCaptureDelegate>

@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCapturePhotoOutput *stillImageOutput;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (strong, nonatomic) UIImage *takenImage;


@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = AVCaptureSessionPresetHigh; //change to medium if Parse size issues
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    else if (self.session && [self.session canAddInput:input]) {
        [self.session addInput:input];
        // The remainder of the session setup will go here...
        
        
        self.stillImageOutput = [AVCapturePhotoOutput new];
        if ([self.session canAddOutput:self.stillImageOutput]) {
            [self.session addOutput:self.stillImageOutput];
            
            //Configure the Live Preview
            self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            if (self.videoPreviewLayer) {
                self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
                [self.previewView.layer addSublayer:self.videoPreviewLayer];
                [self.session startRunning];
            }
            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.videoPreviewLayer.frame = self.previewView.bounds;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTakePhoto:(id)sender {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey: AVVideoCodecTypeJPEG}];
    [self.stillImageOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error {
    
    NSData *imageData = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:imageData];
    self.takenImage = image;
    
    [self performSegueWithIdentifier:@"backToCompose" sender:nil];
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"backToCompose"]){
        ComposeViewController *composeVC = [segue destinationViewController];
        composeVC.chosenImage = self.takenImage;
    }
}


@end
