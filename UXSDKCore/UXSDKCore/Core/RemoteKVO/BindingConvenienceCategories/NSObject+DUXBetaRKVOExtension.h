//
//  NSObject+DUXBetaRKVOExtension.h
//  UXSDKCore
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

NS_ASSUME_NONNULL_BEGIN

/**
 *  Use this class as a parameter to your selector in your bindRKVO call in order to determine what keyPath
 *  changed and what the old and new values are.  This is useful in an instance where you need to run some logic
 *  that depends on a certain order of values.
 */

@interface DUXBetaRKVOTransform : NSObject

@property (nonatomic, copy) NSString* keyPath;
@property (nonatomic, strong) id  oldValue;
@property (nonatomic, strong) id updatedValue;

@end

#ifndef SelfKeypath
#define SelfKeypath(__index__, __property__) @RKVOKeypath(__id_temp_target__ , __property__),
#endif


#ifndef MultiKeyPath
#define MultiKeyPath(...) \
metamacro_foreach(SelfKeypath, , __VA_ARGS__) nil
#endif

/**
 * If you are working in Objective C these macros are avaliable to use rather than the method calls.
 */

#ifndef BindRKVOModel
#define BindRKVOModel(__target__, __SELECTOR__, ...) \
{\
typeof(__target__) __id_temp_target__ = __target__; \
[__target__ duxbeta_bindRKVOWithTarget:self selector:__SELECTOR__ properties:MultiKeyPath(__VA_ARGS__)]; \
}
#endif


#ifndef UnBindRKVOModel
#define UnBindRKVOModel(__target__) [__target__ duxbeta_unBindRKVO]
#endif

/**
 *  Use these methods to receive updates on a list of keypaths when any of them change.  If you are attemping to
 *  to use them from Swift you must use the method that takes a va_list as Objective C variadic parameters don't
 *  bridge to swift.  You can create a va_list by using getVaList and passsing in an array of keyPaths.  Keypaths
 *  can be created in swift using #keypath.
 */

@interface NSObject (DUXBetaRKVOExtension)

/**
 *  Bind a target and its 'property' keyPaths to a selector. This property updates the selector  will be called.
*/
- (void)duxbeta_bindRKVOWithTarget:(id)target selector:(SEL)selector property:(NSString *)property;

/**
 *  Bind a target and it's properties' keyPaths to a selector.  Anytime one of the properties updates the selector
 *  will be called.  If you want to recieve information about which keyPath was updated and the new and old value
 *  have your selector take one parameter of type DUXBetaRKVOTransform.  This method is not avaliable in Swift, if
 *  using swift look at the method that takes a va_list for the variadic parameters.
 */

- (void)duxbeta_bindRKVOWithTarget:(id)target selector:(SEL)selector properties:(NSString *)properties, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  Bind a target and it's properties' keyPaths to a selector.  Anytime one of the properties updates the selector
 *  will be called.  If you want to recieve information about which keyPath was updated and the new and old value
 *  have your selector take one parameter of type DUXBetaRKVOTransform.  This method is avaliable from swift and can
 *  be used by creating a va_list with the getVaList method and passing in an array of keypaths which can be
 *  created using #keypath.
 */

- (void)duxbeta_bindRKVOWithTarget:(id)target selector:(SEL)selector propertiesList:(va_list)properties;

/**
 *  UnBind all keypaths with the current target.
 */

- (void)duxbeta_unBindRKVO;

@end

NS_ASSUME_NONNULL_END
