//
//  DUXBetaRemoteControllerSignalWidgetModel.m
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

#import "DUXBetaRemoteControllerSignalWidgetModel.h"


@interface DUXBetaRemoteControllerSignalWidgetModel ()

@property (nonatomic) NSInteger remoteSignalStrength;
@property (nonatomic, readwrite) DUXBetaRemoteSignalBarsLevel barsLevel;

@end

@implementation DUXBetaRemoteControllerSignalWidgetModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _remoteSignalStrength = 0;
        _barsLevel = DUXBetaRemoteSignalBarsLevel0;
    }
    return self;
}

- (void)inSetup {
    BindSDKKey([DJIAirLinkKey keyWithIndex:0 andParam:DJIAirLinkParamUplinkSignalQuality],remoteSignalStrength);
    BindRKVOModel(self, @selector(remoteSignalStrengthChanged),remoteSignalStrength);
}

- (void)inCleanup {
    UnBindSDK;
    UnBindRKVOModel(self);
}

- (void)remoteSignalStrengthChanged {
    if (self.remoteSignalStrength <= 0 && self.barsLevel != DUXBetaRemoteSignalBarsLevel0) {
        self.barsLevel = DUXBetaRemoteSignalBarsLevel0;
    } else if (self.remoteSignalStrength > 0 && self.remoteSignalStrength < 21 && self.barsLevel != DUXBetaRemoteSignalBarsLevel1) {
        self.barsLevel = DUXBetaRemoteSignalBarsLevel1;
    } else if (self.remoteSignalStrength >= 21 && self.remoteSignalStrength < 41 && self.barsLevel != DUXBetaRemoteSignalBarsLevel2) {
        self.barsLevel = DUXBetaRemoteSignalBarsLevel2;
    } else if (self.remoteSignalStrength >= 41 && self.remoteSignalStrength < 61 && self.barsLevel != DUXBetaRemoteSignalBarsLevel3) {
        self.barsLevel = DUXBetaRemoteSignalBarsLevel3;
    } else if (self.remoteSignalStrength >= 61 && self.remoteSignalStrength < 81 && self.barsLevel != DUXBetaRemoteSignalBarsLevel4) {
        self.barsLevel = DUXBetaRemoteSignalBarsLevel4;
    } else if (self.remoteSignalStrength >= 81 && self.barsLevel != DUXBetaRemoteSignalBarsLevel5) {
        self.barsLevel = DUXBetaRemoteSignalBarsLevel5;
    }
}

@end
