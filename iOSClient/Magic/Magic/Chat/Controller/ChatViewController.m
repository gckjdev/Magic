//
//  ChatViewController.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatToolView.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "ChatCell.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "ChatService.h"
#import "UserManager.h"
#import "ChangeAvatar.h"
#import "ChatCellFrame.h"
#import "MessageTableView.h"
#import "TGRImageViewController.h"
#import "AudioManager.h"
#import "FileUtil.h"
#import "StringUtil.h"
#import "VoiceCacheManager.h"
#import "ChatRecordHintView.h"


#define DEFAULT_SAVE_AUDIO_NAME @"user_talking.wav"

typedef void (^GetVoicePathCallBack) (NSString* filePath);

@interface ChatViewController ()<UITextFieldDelegate,UITextViewDelegate,ChatToolViewDelegate,ChatCellDelegate,AuidoManagerDelegate>


@property (nonatomic,strong) ChatToolView           *toolView;
@property (nonatomic,strong) MessageTableView       *tableView;
@property (nonatomic,strong) NSMutableArray*        messageFrames;
@property (nonatomic, assign) CGFloat               toolViewHeight;
@property (nonatomic,strong) ChangeAvatar           *changeAvatar;
@property (nonatomic,strong) NSString               *tmpMyVoiceFile;
@property (nonatomic,strong) ChatRecordHintView     *recordHintView;
@end



#define MAX_HEIGHT_INPUTVIEW  60.0f
#define CHATTOOLVIEW_HEIGHT  50.0f



@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupTableView];
    [self setupToolView];
    [self setupRecordHintView];
    [self addLeftMenuButton];
    
    [AudioManager sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

#pragma mark - setup

-(void)setupView{
    self.view.backgroundColor = [UIColor colorWithRed:235/255.00 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.title = @"聊天";
    _toolViewHeight = CHATTOOLVIEW_HEIGHT;
    self.changeAvatar = [[ChangeAvatar alloc] init];
}

-(void)setupRecordHintView{
    _recordHintView = [[ChatRecordHintView alloc]init];
    [_recordHintView setHidden:YES];
    [self.view addSubview:_recordHintView];
    [_recordHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CHATRECORDHINTVIEW_WIDTH, CHATRECORDHINTVIEW_HEIGHT));
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-kTabBarHeight);
    }];
}
-(void)setupTableView{
    

    self.tableView = [[MessageTableView alloc]init];
   
    _tableView.viewHeight = _toolViewHeight;
    _tableView.controller = self;
    
    [self.view addSubview:self.tableView];
    

 
    [_tableView refreshData];
    

}

-(void)setupToolView{
    _toolView = [[ChatToolView alloc]init];
    _toolView.contentView.delegate = self;
    _toolView.viewHeight = _toolViewHeight;
    _toolView.delegate = self;
    [self.view addSubview:_toolView];

}



#pragma mark - InputView
- (void)textViewDidChange:(UITextView *)textView
{
   
    [self updateToolView:textView];
}
-(void)changeInputMode:(BOOL)isTalkMode textView:(UITextView*)textView
{
    if (!isTalkMode) {

        [self updateToolView:textView];
        [textView becomeFirstResponder];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:MESSAGE_HAVE_NO_TEXT
                                                           object:nil];
        _toolViewHeight = CHATTOOLVIEW_HEIGHT;
        [self updateLayout];
        [textView resignFirstResponder];
    }
}
-(void)updateToolView:(UITextView *)textView
{
    CGSize size = textView.contentSize;
    
    if (textView.text.length>0) {
        [_toolView.placeHolder setHidden:YES];
    }
    else{
        [_toolView.placeHolder setHidden:NO];
    }
    
    if (size.height<MAX_HEIGHT_INPUTVIEW) {
        _toolViewHeight = CHATTOOLVIEW_HEIGHT + (size.height - MAX_HEIGHT_INPUTVIEW/2);
        [self updateLayout];
    }
    else{
        _toolViewHeight = CHATTOOLVIEW_HEIGHT +  MAX_HEIGHT_INPUTVIEW/2;
        [self updateLayout];
    }
    if (textView.text.length>0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:MESSAGE_HAVE_TEXT
                                                           object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:MESSAGE_HAVE_NO_TEXT
                                                           object:nil];
    }
}
-(void)updateLayout{
    _toolView.viewHeight = _toolViewHeight;
    [_toolView setNeedsUpdateConstraints];
    [_toolView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.4 animations:^{
        [_toolView layoutIfNeeded];
    }];
    
    
    _tableView.viewHeight = _toolViewHeight;
    [_tableView updateConstraintsIfNeeded];
    [_tableView  setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.4 animations:^{
        [_tableView layoutIfNeeded];
    }];
}
#pragma mark - Action

-(void)talkButtonTouchDown
{
    NSString *tmpDir = [FileUtil getAppDocumentDir];

    _tmpMyVoiceFile = [NSString stringWithFormat:@"%@/%@/%@.wav",tmpDir,DEFAULT_SAVE_VOICE,[NSString GetUUID]];
    PPDebug(@"neng : wav save  : %@ ",_tmpMyVoiceFile);
    [[AudioManager sharedInstance]recorderInitWithPath:[NSURL URLWithString:_tmpMyVoiceFile]];
    [[AudioManager sharedInstance]recorderStart];
    
    [_recordHintView setHidden:NO];
}

-(void)talkButtonTouchUpInside
{
    [[AudioManager sharedInstance]recorderStop];
    [_recordHintView setHidden:YES];
 
    
    [[ChatService sharedInstance]sendChatWithAudio:_tmpMyVoiceFile toUserId:@""
                                          callback:^(NSError *error)
    {
        if (error == nil) {
            [_tableView refreshData];
        }
        
    }];
}

-(void)talkButtonTouchCancel
{
    [[AudioManager sharedInstance]recorderCancel];
    [_recordHintView setHidden:YES];
}

-(void)talkButtonTouchUpOutside
{
    [[AudioManager sharedInstance]recorderCancel];
    [_recordHintView setHidden:YES];
}

-(void)sendMessageButtonSingleTouch:(NSString*)text
{
   
    [[ChatService sharedInstance]sendChatWithText:text toUserId:nil callback:^(NSError *error) {
        if (error == nil) {
             [_tableView refreshData];
        }
       
    }];
    
    [self.view endEditing:YES];
}

-(void)plusButtonSingleTouch
{
    
    [self.changeAvatar showSelectionView:self
                                delegate:nil
                      selectedImageBlock:^(UIImage *image) {
                          
                          if (image){
                              [[ChatService sharedInstance]sendChatWithImage:image toUserId:nil callback:^(NSError *error) {
                                  [_tableView refreshData];
                              }];
                              
                          }
                          
                      } didSetDefaultBlock:^{
                          
                      } title:@"请选择"
                         hasRemoveOption:NO
                            canTakePhoto:YES
                       userOriginalImage:YES];
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
#pragma mark - ChatCellDelegate

-(void)imageViewSinglePress:(PBChat*)pbChat image:(UIImage*)image;
{
    TGRImageViewController *vc = [[TGRImageViewController alloc] initWithImage:image];
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)voiceViewSinglePress:(PBChat*)pbChat cell:(ChatCell *)cell
{
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    [_tableView stopPlayingCellAnimation];
    _tableView.playingCellPath = path;
    
    [self getVoiceFile:pbChat callback:^(NSString *filePath) {
       PPDebug(@"neng : filePath %@",filePath);
       [_tableView startPlayingCellAnimation];
        
       [[AudioManager sharedInstance]playInitWithFile:[NSURL URLWithString:filePath]];
       [[AudioManager sharedInstance] playerStart:^(BOOL flag) {
           PPDebug(@"playFinish %d",flag);

           [_tableView stopPlayingCellAnimation];
           
       }];
   }];
}


-(void)getVoiceFile:(PBChat*)pbChat callback:(GetVoicePathCallBack)callback{
    
    NSString* voiceFilePath = [[VoiceCacheManager sharedInstance]
                                       getVoicePath:pbChat.voice] ;
    BOOL isExit = [FileUtil isPathExist:voiceFilePath];
    if (voiceFilePath == nil || !isExit) {
    
        NSString *tempPath = [[FileUtil getAppTempDir]stringByAppendingPathComponent:@"tmpVoice"];
        
        NSString *savePath = [NSString stringWithFormat:@"%@/chatvoice/%@.wav",[FileUtil getAppCacheDir],[NSString GetUUID]];
        [FileUtil createDir:savePath];
        
        [[ChatService sharedInstance]downloadDataFile:pbChat.voice saveFilePath:savePath tempFilePath:tempPath callback:^(NSString *filePath, NSError *error) {
            if (error == nil) {
                PPDebug(@"download voicefile success path = %@",filePath);
             
                [[VoiceCacheManager sharedInstance]setVoicePath:pbChat.voice filePath:filePath.lastPathComponent];
                EXECUTE_BLOCK(callback,filePath);
            
            }
            else{
                PPDebug(@"download voicefile fail");
            }
        }];
        
    }
    EXECUTE_BLOCK(callback,voiceFilePath);
}
#pragma mark - AudioManagerDelegate
-(void)recordingUpdateImage:(NSInteger) volumeNum
{
    PPDebug(@"neng : volumeNum %d",volumeNum);
    [_recordHintView updateVolumeImage:volumeNum];
    
}
@end
