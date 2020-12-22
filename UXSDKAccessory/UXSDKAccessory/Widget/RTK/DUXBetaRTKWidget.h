//
//  DUXBetaRTKSatelliteStatusWidget.h
//  UXSDKAccessory
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

#import "DUXBetaRTKEnabledWidget.h"
#import "DUXBetaRTKSatelliteStatusWidget.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUXBetaRTKWidget : DUXBetaBaseWidget

/**
 *  The DUXBetaRTKEnabledWidget positioned at the top of the widget.
*/
@property (nonatomic, strong) DUXBetaRTKEnabledWidget *rtkEnabledWidget;

/**
 *  The DUXBetaRTKSatelliteStatusWidget positioned near the bottom of the widget.
*/
@property (nonatomic, strong) DUXBetaRTKSatelliteStatusWidget *rtkSatelliteStatusWidget;

/**
 *  The font of the RTK description label. Default point size = 11.0.
*/
@property (nonatomic, strong) UIFont *rtkDescriptionFont;

/**
 *  The text color of the RTK description label.
*/
@property (nonatomic, strong) UIColor *rtkDescriptionTextColor;

/**
 *  The background color of the RTK description label.
*/
@property (nonatomic, strong) UIColor *rtkDescriptionBackgroundColor;

/**
 *  The font of the OK button. Default point size = 16.0.
*/
@property (nonatomic, strong) UIFont *okFont;

/**
 *  The text color of the OK button.
*/
@property (nonatomic, strong) UIColor *okTextColor;

/**
 *  The background color of the OK button.
*/
@property (nonatomic, strong) UIColor *okBackgroundColor;

/**
 *  The color of the separator lines for this widget and all sub-widgets.
*/
@property (nonatomic, strong) UIColor *separatorColor;

/**
 *  The background color of the widget.
*/
@property (nonatomic, strong) UIColor *backgroundColor;



@end

NS_ASSUME_NONNULL_END
