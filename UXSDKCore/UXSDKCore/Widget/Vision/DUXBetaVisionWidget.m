//
//  DUXBetaVisionWidget.m
//  UXSDKCore
//
//  MIT License
//  
//  Copyright © 2018-2020 DJI
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "DUXBetaVisionWidget.h"
#import "UIImage+DUXBetaAssets.h"
#import "UIColor+DUXBetaColors.h"
#import "DUXBetaStateChangeBroadcaster.h"
#import "NSLayoutConstraint+DUXBetaMultiplier.h"

static NSString * const DUXBetaVisionWidgetWarningMessageReason = @"Obstacle Avoidance Disabled.";
static NSString * const DUXBetaVisionWidgetWarningMessageSolution = @"Fly with caution.";

@interface DUXBetaVisionWidget ()

@property (nonatomic, strong) UIImageView *visionImageView;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIImage *> *visionImageMapping;
@property (nonatomic) CGSize minWidgetSize;
@property (nonatomic, strong) NSLayoutConstraint *widgetAspectRatioConstraint;

@end

/**
 * VisionSignalUIState contains the hooks for UI changes in the widget class DUXBetaVisionWidget.
 * It implements the hook:
 *
 * Key: widgetTapped    Type: NSNumber - Sends a boolean YES value as an NSNumber indicating the widget was tapped.
*/
@interface VisionSignalUIState : DUXBetaStateChangeBaseData

+ (instancetype)widgetTapped;

@end

/**
 * VisionWidgetModelState contains the model hooks for the DUXBetaVisionWidget.
 * It implements the hooks:
 *
 * Key: productConnected            Type: NSNumber - Sends a boolean value as an NSNumber indicating if an aircraft is connected.
 *
 * Key: visionSystemStatusUpdated   Type: NSNumber - Sends the updated DUXBetaVisionStatus value as an NSNumber whenever it changes.
 *
 * Key: userAvoidanceEnabledUpdated Type: NSNumber - Sends a boolean value as an NSNunber indicating if obstacle avoidance has
 *                                                   been enabled by the user. YES is obstacle avoidance enabled, NO is deactivated
 *
 * Key: visibilityUpdated           Type: NSNumber - Sends a boolean value as an NSNumber when the aircraft model changes (during
 *                                                   connection/disconnection) to indicate if aircraft supports vision.
*/
@interface VisionModelState : DUXBetaStateChangeBaseData

+ (instancetype)productConnected:(BOOL)isConnected;
+ (instancetype)visionSystemStatusUpdated:(DUXBetaVisionStatus)visionStatus;
+ (instancetype)userAvoidanceEnabledUpdated:(BOOL)isUserAvoidanceEnabled;
+ (instancetype)visibilityUpdated:(BOOL)isVisible;

@end

@implementation DUXBetaVisionWidget

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupInstanceVariables];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupInstanceVariables];
    }
    return self;
}

- (void)setupInstanceVariables {
    _visionImageMapping = [[NSMutableDictionary alloc] initWithDictionary:@{
        @(DUXBetaVisionStatusNormal) : [UIImage duxbeta_imageWithAssetNamed:@"VisionEnabled"],
        @(DUXBetaVisionStatusDisabled) : [UIImage duxbeta_imageWithAssetNamed:@"VisionDisabled"],
        @(DUXBetaVisionStatusClosed) : [UIImage duxbeta_imageWithAssetNamed:@"VisionClosed"],
        @(DUXBetaVisionStatusOmniAll) : [UIImage duxbeta_imageWithAssetNamed:@"VisionAllSensorsEnabled"],
        @(DUXBetaVisionStatusOmniFrontBack) : [UIImage duxbeta_imageWithAssetNamed:@"VisionLeftRightSensorsDisabled"],
        @(DUXBetaVisionStatusOmniVertical) : [UIImage duxbeta_imageWithAssetNamed:@"VisionVertical"],
        @(DUXBetaVisionStatusOmniHorizontal) : [UIImage duxbeta_imageWithAssetNamed:@"VisionHorizontal"],
        @(DUXBetaVisionStatusOmniDisabled) : [UIImage duxbeta_imageWithAssetNamed:@"VisionAllSensorsDisabled"],
        @(DUXBetaVisionStatusOmniClosed) : [UIImage duxbeta_imageWithAssetNamed:@"VisionAllSensorsDisabled"],
        @(DUXBetaVisionStatusUnknown) : [UIImage duxbeta_imageWithAssetNamed:@"VisionDisabled"]
    }];
    
    _iconBackgroundColor = [UIColor clearColor];
    _disconnectedIconColor = [UIColor uxsdk_disabledGrayWhite58];
    
    [self updateMinImageDimensions];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.widgetModel = [[DUXBetaVisionWidgetModel alloc] init];
    [self.widgetModel setup];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BindRKVOModel(self, @selector(updateUI), iconBackgroundColor, disconnectedIconColor);
    BindRKVOModel(self.widgetModel, @selector(updateUI), visionSystemStatus, currentAircraftSupportVision, isProductConnected);
    
    BindRKVOModel(self.widgetModel, @selector(sendIsProductConnected), isProductConnected);
    BindRKVOModel(self.widgetModel, @selector(sendVisionSystemStatusUpdate), visionSystemStatus);
    BindRKVOModel(self.widgetModel, @selector(sendVisionDisabledWarning), isCollisionAvoidanceEnabled);
    BindRKVOModel(self.widgetModel, @selector(sendVisibilityUpdate), currentAircraftSupportVision);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UnBindRKVOModel(self);
    UnBindRKVOModel(self.widgetModel);
}

- (void)dealloc {
    [self.widgetModel cleanup];
}

- (void)setupUI {
    UIImage *image = [self.visionImageMapping objectForKey:@(self.widgetModel.visionSystemStatus)];
    self.visionImageView = [[UIImageView alloc] initWithImage:image];
    self.visionImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.visionImageView];
    
    CGFloat imageAspectRatio = image.size.width / image.size.height;

    self.widgetAspectRatioConstraint = [self.view.widthAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:imageAspectRatio];
    self.widgetAspectRatioConstraint.active = YES;
    [self.visionImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.visionImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.visionImageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.visionImageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    self.visionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self updateUI];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(widgetTapped)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)updateUI {
    self.visionImageView.backgroundColor = self.iconBackgroundColor;
    self.visionImageView.image = [self.visionImageMapping objectForKey:@(self.widgetModel.visionSystemStatus)];

    if (!self.widgetModel.isProductConnected) {
        UIImage *tintableImage = [self.visionImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.visionImageView.image = tintableImage;
        [self.visionImageView setTintColor:self.disconnectedIconColor];
    }
    
    if (self.widgetModel.currentAircraftSupportVision) {
        [self.view setHidden:NO];
    } else {
        [self.view setHidden:YES];
    }
}

- (void)sendIsProductConnected {
    [[DUXBetaStateChangeBroadcaster instance] send:[VisionModelState productConnected:self.widgetModel.isProductConnected]];
}

- (void)sendVisionSystemStatusUpdate {
    [[DUXBetaStateChangeBroadcaster instance] send:[VisionModelState visionSystemStatusUpdated:self.widgetModel.visionSystemStatus]];
}

- (void)sendVisibilityUpdate {
    [[DUXBetaStateChangeBroadcaster instance] send:[VisionModelState visibilityUpdated:self.widgetModel.currentAircraftSupportVision]];
}

- (void)sendVisionDisabledWarning {
    // Send Hook
    [[DUXBetaStateChangeBroadcaster instance] send:[VisionModelState userAvoidanceEnabledUpdated:self.widgetModel.isCollisionAvoidanceEnabled]];
    // Send Warning Message
    [self.widgetModel sendWarningMessageWithReason:DUXBetaVisionWidgetWarningMessageReason andSolution:DUXBetaVisionWidgetWarningMessageSolution];
}

- (void)setImage:(UIImage *)image forVisionStatus:(DUXBetaVisionStatus)status {
    [self.visionImageMapping setObject:image forKey:@(status)];
    [self updateMinImageDimensions];
    [self updateUI];
}

- (UIImage *)imageForVisionStatus:(DUXBetaVisionStatus)status {
    return [self.visionImageMapping objectForKey:@(status)];
}

- (void)widgetTapped {
    [[DUXBetaStateChangeBroadcaster instance] send:[VisionSignalUIState widgetTapped]];
}

- (void)updateMinImageDimensions {
    _minWidgetSize = [self maxSizeInImageArray:self.visionImageMapping.allValues];
    [self.widgetAspectRatioConstraint duxbeta_updateMultiplier:self.widgetSizeHint.preferredAspectRatio];
}

- (DUXBetaWidgetSizeHint)widgetSizeHint {
    DUXBetaWidgetSizeHint hint = {self.minWidgetSize.width / self.minWidgetSize.height, self.minWidgetSize.width, self.minWidgetSize.height};
    return hint;
}

@end

@implementation VisionSignalUIState

+ (instancetype)widgetTapped {
    return [[VisionSignalUIState alloc] initWithKey:@"widgetTapped" number:@(0)];
}

@end

@implementation VisionModelState

+ (instancetype)productConnected:(BOOL)isConnected {
    return [[VisionModelState alloc] initWithKey:@"productConnected" number:@(isConnected)];
}

+ (instancetype)visionSystemStatusUpdated:(DUXBetaVisionStatus)visionStatus {
    return [[VisionModelState alloc] initWithKey:@"visionSystemStatusUpdated" number:@(visionStatus)];
}

+ (instancetype)userAvoidanceEnabledUpdated:(BOOL)isUserAvoidanceEnabled {
    return [[VisionModelState alloc] initWithKey:@"userAvoidanceEnabledUpdated" number:@(isUserAvoidanceEnabled)];
}

+ (instancetype)visibilityUpdated:(BOOL)isVisible {
    return [[VisionModelState alloc] initWithKey:@"visibilityUpdated" number:@(isVisible)];
}

@end
