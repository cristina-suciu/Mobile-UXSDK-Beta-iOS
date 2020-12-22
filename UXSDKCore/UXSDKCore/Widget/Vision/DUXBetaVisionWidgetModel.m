//
//  DUXBetaVisionWidgetModel.m
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

#import "DUXBetaVisionWidgetModel.h"
#import "DUXBetaWarningMessage.h"

#import <UXSDKCore/UXSDKCore-Swift.h>

@interface DUXBetaVisionWidgetModel()

//Exposed properties
@property (nonatomic, readwrite) DUXBetaVisionStatus visionSystemStatus;
@property (nonatomic, readwrite) BOOL isCollisionAvoidanceEnabled;
@property (nonatomic, readwrite) BOOL currentAircraftSupportVision;

// Private properties
@property (nonatomic) BOOL isLeftRightSensorEnabled;
@property (nonatomic) BOOL isNoseTailSensorEnabled;
@property (nonatomic) BOOL isSensorWorking;
@property (strong, nonatomic) NSString *aircraftModel;
@property (assign, nonatomic) DJIFlightMode flightMode;
@property (strong, nonatomic) DJITapFlyMissionOperator *tapFlyOperator;
@property (strong, nonatomic) DJIActiveTrackMissionOperator *activeTrackOperator;
@property (strong, nonatomic) DJIFlightAssistantObstacleAvoidanceSensorState *avoidanceStateM300;
@property (nonatomic) BOOL isUpwardAvoidanceEnabled;

@end

@implementation DUXBetaVisionWidgetModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _aircraftModel = DJIAircraftModelNameUnknownAircraft;
        _flightMode = DJIFlightModeUnknown;
        _isSensorWorking = NO;
        _isCollisionAvoidanceEnabled = NO;
        _isLeftRightSensorEnabled = NO;
        _isNoseTailSensorEnabled = NO;
        _visionSystemStatus = DUXBetaVisionStatusUnknown;
        _activeTrackOperator = [[DJISDKManager missionControl] activeTrackMissionOperator];
        _tapFlyOperator = [[DJISDKManager missionControl] tapFlyMissionOperator];
        _isUpwardAvoidanceEnabled = NO;
    }
    return self;
}

- (void)inSetup {
    BindSDKKey([DJIProductKey keyWithParam:DJIProductParamModelName], aircraftModel);
    BindSDKKey([DJIFlightControllerKey keyWithParam:DJIFlightControllerParamFlightMode], flightMode);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0
                                       subComponent:DJIFlightControllerFlightAssistantSubComponent
                                  subComponentIndex:0
                                           andParam:DJIFlightAssistantParamIsSensorBeingUsed], isSensorWorking);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0
                                       subComponent:DJIFlightControllerFlightAssistantSubComponent
                                  subComponentIndex:0
                                           andParam:DJIFlightAssistantParamCollisionAvoidanceEnabled], isCollisionAvoidanceEnabled);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0
                                       subComponent:DJIFlightControllerFlightAssistantSubComponent
                                  subComponentIndex:0
                                           andParam:DJIFlightAssistantParamVisionLeftRightSensorEnabled], isLeftRightSensorEnabled);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0
                                       subComponent:DJIFlightControllerFlightAssistantSubComponent
                                  subComponentIndex:0
                                           andParam:DJIFlightAssistantParamVisionNoseTailSensorEnabled], isNoseTailSensorEnabled);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0
                                       subComponent:DJIFlightControllerFlightAssistantSubComponent
                                  subComponentIndex:0
                                           andParam:DJIFlightAssistantParamUpwardsAvoidanceEnabled], isUpwardAvoidanceEnabled);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0
                                       subComponent:DJIFlightControllerFlightAssistantSubComponent
                                  subComponentIndex:0
                                           andParam:DJIFlightAssistantParamAvoidanceState], avoidanceStateM300);

    BindRKVOModel(self, @selector(updateStates), isSensorWorking, aircraftModel, isCollisionAvoidanceEnabled, flightMode, isNoseTailSensorEnabled, isLeftRightSensorEnabled, isUpwardAvoidanceEnabled, avoidanceStateM300);
}

- (void)inCleanup {
    UnBindSDK;
    UnBindRKVOModel(self);
}

- (void)updateStates {
    self.currentAircraftSupportVision = [ProductUtil isVisionSupportedProduct];
    if (self.avoidanceStateM300 && [self.aircraftModel isEqualToString:DJIAircraftModelNameMatrice300RTK]) {
        DUXBetaVisionStatus verticalStatus = DUXBetaVisionStatusUnknown;
        DUXBetaVisionStatus horizontalStatus = DUXBetaVisionStatusUnknown;
        if (self.avoidanceStateM300.isVisualObstacleAvoidanceSensorInVerticalDirectionEnabled &&
            self.avoidanceStateM300.isVisualObstacleAvoidanceSensorsInVerticalDirectionWorking &&
            self.isUpwardAvoidanceEnabled) {
           verticalStatus = DUXBetaVisionStatusNormal;
        } else {
           verticalStatus = DUXBetaVisionStatusClosed;
        }

        if (self.avoidanceStateM300.isVisualObstacleAvoidanceSensorsInHorizontalDirectionEnabled &&
            self.avoidanceStateM300.isVisualObstacleAvoidanceSensorInHorizontalDirectionWorking &&
           self.isCollisionAvoidanceEnabled) {
           horizontalStatus = DUXBetaVisionStatusNormal;
        } else {
           horizontalStatus = DUXBetaVisionStatusClosed;
        }

        if (verticalStatus == DUXBetaVisionStatusNormal && horizontalStatus == DUXBetaVisionStatusNormal) {
           self.visionSystemStatus = DUXBetaVisionStatusOmniAll;
           return;
        } else if (verticalStatus == DUXBetaVisionStatusNormal) {
           self.visionSystemStatus = DUXBetaVisionStatusOmniVertical;
           return;
        } else if (horizontalStatus == DUXBetaVisionStatusNormal) {
           self.visionSystemStatus = DUXBetaVisionStatusOmniHorizontal;
           return;
        } else {
           self.visionSystemStatus = DUXBetaVisionStatusOmniClosed;
           return;
        }
    }
    
    if (!self.isSensorWorking) {
        self.visionSystemStatus = DUXBetaVisionStatusDisabled;
        return;
    }

    if ([ProductUtil isMavic2Series] && ![ProductUtil isMavic2EnterpriseSeries]) {
        self.visionSystemStatus = [self visionStatusForMavic2];
    } else if ([ProductUtil isMavic2EnterpriseSeries]) {
        self.visionSystemStatus = [self visionStatusForMavic2Enterprise];
    } else {
        if (!self.isCollisionAvoidanceEnabled) {
            self.visionSystemStatus = DUXBetaVisionStatusClosed;
        } else if (![self isVisionSystemEnabled]) {
            self.visionSystemStatus = DUXBetaVisionStatusDisabled;
        } else {
            self.visionSystemStatus = DUXBetaVisionStatusNormal;
        }
    }
}

// Mavic2 series and Mavic2Enterprise series are the only drones which support vision in 4 directions
- (DUXBetaVisionStatus)visionStatusForMavic2 {
    if (self.isCollisionAvoidanceEnabled) {
        if (self.isLeftRightSensorEnabled && self.isNoseTailSensorEnabled && [self isVisionSystemEnabled]) {
            return DUXBetaVisionStatusOmniAll;
        } else if (!self.isLeftRightSensorEnabled && self.isNoseTailSensorEnabled && [self isVisionSystemEnabled]) {
            return DUXBetaVisionStatusOmniFrontBack;
        } else {
            return DUXBetaVisionStatusOmniDisabled;
        }
    } else {
        return DUXBetaVisionStatusOmniClosed;
    }
}

// Mavic2enterprise gets bad nose-tail vision readings when the drone isn't flying,
// this is why we show left-right disabled when the flight mode supports vision but isNoseTailSensorEnabled is false
- (DUXBetaVisionStatus)visionStatusForMavic2Enterprise {
    if (self.isCollisionAvoidanceEnabled) {
        if (self.isLeftRightSensorEnabled && self.isNoseTailSensorEnabled) {
            return DUXBetaVisionStatusOmniAll;
        } else if (self.isNoseTailSensorEnabled || [self isVisionSystemEnabled]) {
            return DUXBetaVisionStatusOmniFrontBack;
        } else {
            return DUXBetaVisionStatusOmniDisabled;
        }
    } else {
        return DUXBetaVisionStatusOmniClosed;
    }
}

- (BOOL)isVisionSystemEnabled {
    DJITapFlyMode tapFlyMode = self.tapFlyOperator.mode;

    BOOL visionUnsupportedForActiveTrackMode = ([self.activeTrackOperator trackingMode] != DJIActiveTrackModeTrace &&
                                                self.activeTrackOperator.trackingMode != DJIActiveTrackModeSpotlight &&
                                                self.activeTrackOperator.trackingMode != DJIActiveTrackModeSpotlightPro &&
                                                self.activeTrackOperator.trackingMode != DJIActiveTrackModeQuickShot);

    if (self.flightMode == DJIFlightModeAtti
        || self.flightMode == DJIFlightModeGPSSport
        || self.flightMode == DJIFlightModeAutoLanding
        || self.flightMode == DJIFlightModeActiveTrackSpotlight
        || self.flightMode == DJIFlightModeUnknown
        || self.flightMode == DJIFlightModeDraw) {
        return NO;
    } else if (self.flightMode == DJIFlightModeActiveTrack && visionUnsupportedForActiveTrackMode) {
        return NO;
    } else if (self.flightMode == DJIFlightModeTapFly && tapFlyMode == DJITapFlyModeFree) {
        return NO;
    } else {
        return YES;
    }
}

- (void)sendWarningMessageWithReason:(NSString *)reason andSolution:(NSString *)solution {
    DUXBetaWarningMessageKey *warningMessageKey = [[DUXBetaWarningMessageKey alloc] initWithIndex:0
                                                                                parameter:DUXBetaWarningMessageParameterSendWarningMessage];
    DUXBetaWarningMessage *warningMessage = [[DUXBetaWarningMessage alloc] init];
    warningMessage.reason = reason;
    warningMessage.solution = solution;
    warningMessage.level = DUXBetaWarningMessageLevelWarning;
    warningMessage.type = DUXBetaWarningMessageTypeAutoDisappear;
    if (self.isCollisionAvoidanceEnabled) {
        warningMessage.action = DUXBetaWarningMessageActionRemove;
    } else {
        warningMessage.action = DUXBetaWarningMessageActionInsert;
    }
    
    ModelValue *warningMessageModel = [[ModelValue alloc] initWithValue:[warningMessage copy]];
    
    [[DUXBetaSingleton sharedObservableInMemoryKeyedStore] setModelValue:warningMessageModel forKey:warningMessageKey];
}

@end
