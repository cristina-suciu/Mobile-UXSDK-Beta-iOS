//
//  DUXBetaSingleton.h
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

#import <Foundation/Foundation.h>

@protocol ObservableKeyedStore;
@protocol GlobalPreferences;

NS_ASSUME_NONNULL_BEGIN

// Super singleton class that will contain classes that need a singleton instance.
// All sigleton classes used here can be created in a deterministic order.
// Please create and reference your singleton object here instead of creating another singleton to avoid bugs.
@interface DUXBetaSingleton : NSObject

+ (id <ObservableKeyedStore>)sharedObservableInMemoryKeyedStore;

+ (id <GlobalPreferences>)sharedGlobalPreferences;

+ (void)setSharedGlobalPreferences:(id <GlobalPreferences>)sharedGlobalPreferences;

@end

NS_ASSUME_NONNULL_END
