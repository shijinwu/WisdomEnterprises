//
//  MeViewController.m
//  WisdomEnterprises
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "EditNormalInfoController.h"

#import "EaseUI.h"
#import "UIViewController+HUD.h"
#import "EditGenderController.h"

#import "MeViewController.h"
#import "UIColor+WXExtension.h"
#import "UIView+Function.h"
#import "UIViewController+Function.h"
#import "InfoManager.h"
#import <Masonry/Masonry.h>
#import "UIImageView+EMWebCache.h"

#import "ChangePasswordViewController.h"

@implementation UIImage (UIImageExt)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>


@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * showDataSource;

@property (nonatomic,strong)InfoManager * infoManager;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) UIImageView *headImageView;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.infoManager = [InfoManager shareManager];
    
    [self setupUI];
    
    [self addShowDataSource];
}

-(void)setupUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.height =self.view.height -64-44;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.tableView];
    
}

-(void)addShowDataSource
{
    NSArray * section0 = @[@"",@"昵称",@"真实姓名",@"手机号码",@"性别",@"爱好"];
    NSArray * section1 = @[@"设置密码"];
    NSArray * section2 = @[@"退出帐号"];
    
    self.showDataSource = @[section0,section1,section2];
    
}


- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.showDataSource.count;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.showDataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 2 || (indexPath.section == 0&&indexPath.row == 0)) {
        
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
  
    
    
    cell.textLabel.text = self.showDataSource[indexPath.section][indexPath.row];
    
    [self setCellInfoWithIndexPath:indexPath cell:cell];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section== 0 && indexPath.row == 0) {
        
        return 220;
    }
   
    return 60;
}


-(void)setCellInfoWithIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell{
   

    UIView * v =  [cell.contentView viewWithTag:10001];
    if (v) {
        [v  removeFromSuperview];
    }
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.contentView.backgroundColor = [UIColor colorWithR:37 G:37 B:37 Alpha:1];
            
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.origin = CGPointMake(self.view.width/2-60,110-60);
            imageView.size = CGSizeMake(120, 120);
            
            imageView.layer.cornerRadius = 60;
            
            imageView.layer.masksToBounds = YES;
            
            imageView.backgroundColor = [UIColor orangeColor];
            [cell.contentView addSubview:imageView];
            
            imageView.tag = 10001;
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.infoManager.user.imageUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
            
            self.headImageView = imageView;
            
        }else
        {
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.right-200,10, 150, 40)];
            
            label.tag = 10001;
            
            //label.backgroundColor = [UIColor orangeColor];
            
            label.textColor = [UIColor blackColor];
            
            label.textAlignment = NSTextAlignmentRight;
            
            [cell.contentView addSubview:label];
            
            switch (indexPath.row) {
                case 1:
                    label.text = self.infoManager.user.nickName;
                    break;
                case 2:
                    label.text = self.infoManager.user.name;
                    break;
                case 3:
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    label.text = self.infoManager.user.tel;
                    break;
                case 4:
                    label.text = self.infoManager.user.gender;
                    break;
                case 5:
                    label.text = self.infoManager.user.hobby;
                    break;
                    
                default:
                    break;
            }
    }
    
    }
    else if (indexPath.section == 2){
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showDetailViewControllerWithIndexPath:indexPath];
}

-(void)showDetailViewControllerWithString:(NSString *)string indexPath:(NSIndexPath *)indexPath showController:(UIViewController *)controller
{
    
    [controller setValue:string forKey:@"titleStr"];
    
    [controller setSaveInfo:^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }];
    [self.navigationController pushViewController:controller animated:NO];
   
}

-(void)showActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"setting.cameraUpload", @"Take photo"),NSLocalizedString(@"setting.localUpload", @"Photos"), nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

/*点击不同cell跳转不同页面*/
-(void)showDetailViewControllerWithIndexPath:(NSIndexPath *)indexPath{
    
     UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self showActionSheet];
        }
        else if (indexPath.row == 3){
            
            [self showHint:@"电话不可被修改"];
        }
        else if (indexPath.row == 4){
            [self showDetailViewControllerWithString:cell.textLabel.text indexPath:indexPath showController:[EditGenderController new]];
        }
        else{
           
             [self showDetailViewControllerWithString:cell.textLabel.text indexPath:indexPath showController:[EditNormalInfoController new]];
            
        }
        
    }
    else if (indexPath.section == 1){
        
        // 设置密码
        
        ChangePasswordViewController * v = [[UIStoryboard storyboardWithName:@"Me" bundle:nil]instantiateViewControllerWithIdentifier:@"changePassword"];
        
        [self.navigationController pushViewController:v animated:YES];
        
    }
    else{
        
        [self logoutAction];
       // 退出登录
        
    }
    
}

- (void)logoutAction
{
    __weak MeViewController *weakSelf = self;
    [self showHudInView:self.view hint:NSLocalizedString(@"setting.logoutOngoing", @"loging out...")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] logout:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (error != nil) {
                [weakSelf showHint:error.errorDescription];
            }
            else{
                //[[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            }
        });
    });
}



#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self hideHud];
    //[self showHudInView:self.view hint:NSLocalizedString(@"setting.uploading", @"uploading...")];
    
    __weak typeof(self) weakSelf = self;
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (orgImage) {
          // 上传图片
         UIImage *img = [orgImage imageByScalingAndCroppingForSize:CGSizeMake(120.f, 120.f)];
        
        self.headImageView.image = img;
         [self hideHud];
           } else {
        [self hideHud];
        [self showHint:NSLocalizedString(@"setting.uploadFail", @"uploaded failed")];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
#if TARGET_IPHONE_SIMULATOR
        [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
        } else {
            
        }
#endif
    } else if (buttonIndex == 1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
        
    }
}



@end
