//
//  TLChatFontViewController.m
//  TLChat
//
//  Created by 李伯坤 on 16/3/21.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLChatFontViewController.h"
#import "TLChatTableViewController.h"
#import "TLChatFontSettingView.h"
#import "TLUser+ChatModel.h"

@interface TLChatFontViewController ()

@property (nonatomic, strong) TLChatTableViewController *chatTVC;

@property (nonatomic, strong) TLChatFontSettingView *chatFontSettingView;

@end


@implementation TLChatFontViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"字体大小"];
    
    [self.view addSubview:self.chatTVC.view];
    [self addChildViewController:self.chatTVC];
    [self.view addSubview:self.chatFontSettingView];
    [self p_addMasonry];
    
    __weak typeof(self) weakSelf = self;
    [self.chatFontSettingView setFontSizeChangeTo:^(CGFloat size) {
        [[NSUserDefaults standardUserDefaults] setDouble:size forKey:@"CHAT_FONT_SIZE"];
        weakSelf.chatTVC.data = [weakSelf p_chatTVCData];
        [weakSelf.chatTVC.tableView reloadData];
    }];
    CGFloat size = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CHAT_FONT_SIZE"];
    [self.chatFontSettingView setCurFontSize:size];
    self.chatTVC.data = [self p_chatTVCData];
}

#pragma mark - Private Methods -
- (void)p_addMasonry
{
    [self.chatTVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.chatFontSettingView.mas_top);
    }];
    
    [self.chatFontSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(self.chatFontSettingView.mas_width).multipliedBy(0.4);
    }];
}

- (NSMutableArray *)p_chatTVCData
{
    TLTextMessage *message = [[TLTextMessage alloc] init];
    message.fromUser = [TLUserHelper sharedHelper].user;
    message.messageType = TLMessageTypeText;
    message.ownerTyper = TLMessageOwnerTypeSelf;
    message.text = @"预览字体大小";
    
    TLUser *user = [[TLUser alloc] init];
    user.avatarPath = @"AppIcon";
    NSString *path = [NSFileManager pathUserAvatar:@"AppIcon"];
    if (![[NSFileManager defaultManager] isExecutableFileAtPath:path]) {
        NSString *iconPath = [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        UIImage *image = [UIImage imageNamed:iconPath];
        NSData *data = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 1));
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    }
    
    
    TLTextMessage *message1 = [[TLTextMessage alloc] init];
    message1.fromUser = user;
    message1.messageType = TLMessageTypeText;
    message1.ownerTyper = TLMessageOwnerTypeFriend;
    message1.text = @"拖动下面的滑块，可设置字体大小";
    TLTextMessage *message2 = [[TLTextMessage alloc] init];
    message2.fromUser = user;
    message2.messageType = TLMessageTypeText;
    message2.ownerTyper = TLMessageOwnerTypeFriend;
    message2.text = @"设置后，会改变聊天页面的字体大小。后续将支持更改菜单、朋友圈的字体修改。";
    
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:message, message1, message2, nil];
    return data;
}


#pragma mark - Getter -
- (TLChatTableViewController *)chatTVC
{
    if (_chatTVC == nil) {
        _chatTVC = [[TLChatTableViewController alloc] init];
        [_chatTVC setDisablePullToRefresh:YES];
        [_chatTVC setDisableLongPressMenu:YES];
    }
    return _chatTVC;
}

- (TLChatFontSettingView *)chatFontSettingView
{
    if (_chatFontSettingView == nil) {
        _chatFontSettingView = [[TLChatFontSettingView alloc] init];
    }
    return _chatFontSettingView;
}

@end
