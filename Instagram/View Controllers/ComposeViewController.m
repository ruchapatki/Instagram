//
//  ComposeViewController.m
//  Instagram
//
//  Created by Rucha Patki on 7/9/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "MBProgressHud.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    if(self.chosenImage != nil){
        self.imageView.image = self.chosenImage;
    }
}

-(void)dismissKeyboard
{
    [self.captionTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTap:(id)sender {
    //gesture recog tapped
    //instantiate UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
//    [self performSegueWithIdentifier:@"myCam" sender:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self performSegueWithIdentifier:@"myCam" sender:nil];
//        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self photoLib];
    }
}

- (void) photoLib {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.imageView.image = editedImage;
    
//    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapShare:(id)sender {
    
    if(self.imageView.image != nil){
        //resize image for parse
        CGSize mySize = CGSizeMake(250,250);
        UIImage *resizedImg = [self resizeImage:self.imageView.image withSize:mySize];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //share image
        NSString *caption = self.captionTextView.text;
        [Post postUserImage:resizedImg withCaption:caption withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Succesfully shared image");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.imageView.image = [UIImage imageNamed:@"image_placeholder"];
                self.captionTextView.text = @"";
            }
        }];
    }
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
