//
//  DUXBetaListItemTrivialSwitchWidget.h
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

#import "DUXBetaListItemSwitchWidget.h"

NS_ASSUME_NONNULL_BEGIN

@interface DUXBetaListItemTrivialSwitchWidget : DUXBetaListItemSwitchWidget

- (instancetype)setTitle:(NSString*)titleString andKey:(DJIKey*)theKey;
- (instancetype)setTitle:(NSString*)titleString iconName:(NSString* _Nullable)iconName andKey:(DJIKey*)theKey;

- (void)valueForSwitchChanged;

@end

/**
 * ListItemTrivalModelUIState contains the hooks for UI changes in the widget class DUXBetaListItemTrivialSwitchWidget.
 * It implements the hook:
 *
 * Key: switchModelValueChanged    Type: NSNumber - Sends a boolean value as an NSNumber indicating the new value
 *                                                  of the switch value when it changes.
 *
*/
@interface ListItemTrivalModelUIState : DUXBetaStateChangeBaseData
+ (instancetype)switchModelValueChanged:(BOOL)isOn;
@end

NS_ASSUME_NONNULL_END
