//
//  DUXBetaRadarWidgetModel.m
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

#import "DUXBetaRadarWidgetModel.h"

@interface DUXBetaRadarWidgetModel()

@property (nonatomic, assign, readwrite) DJIVisionDetectionState *noseState;
@property (nonatomic, assign, readwrite) DJIVisionDetectionState *tailState;
@property (nonatomic, assign, readwrite) DJIVisionDetectionState *rightState;
@property (nonatomic, assign, readwrite) DJIVisionDetectionState *leftState;
@property (nonatomic, assign, readwrite) DJIVisionControlState *controlState;

@end

@implementation DUXBetaRadarWidgetModel

- (void)inSetup {
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0 subComponent:DJIFlightControllerFlightAssistantSubComponent subComponentIndex:0 andParam:DJIFlightAssistantParamVisionDetectionNoseState], noseState);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0 subComponent:DJIFlightControllerFlightAssistantSubComponent subComponentIndex:0 andParam:DJIFlightAssistantParamVisionDetectionTailState], tailState);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0 subComponent:DJIFlightControllerFlightAssistantSubComponent subComponentIndex:0 andParam:DJIFlightAssistantParamVisionDetectionRightState], rightState);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0 subComponent:DJIFlightControllerFlightAssistantSubComponent subComponentIndex:0 andParam:DJIFlightAssistantParamVisionDetectionLeftState], leftState);
    BindSDKKey([DJIFlightControllerKey keyWithIndex:0 subComponent:DJIFlightControllerFlightAssistantSubComponent subComponentIndex:0 andParam:DJIFlightAssistantParamVisionControlState], controlState);
    BindRKVOModel(self, @selector(update), noseState, tailState, rightState, leftState, controlState);
}

- (void)inCleanup {
    UnBindSDK;
    UnBindRKVOModel(self);
}

- (void)update {  
}

@end
