//
//  DUXBetaCustomValueConfirmation.m
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

#import "DUXBetaCustomValueConfirmation.h"
#import "DUXBetaCustomValueConfirmation_Private.h"

@implementation DUXBetaCustomValueConfirmation

- (void)accept
{
    if (self.delegate)
    {
        [self.delegate confirmation:self acceptWithValue:self.settingValue];
    }
}

- (void)acceptWithValue:(nullable id)value
{
    if (self.delegate)
    {
        [self.delegate confirmation:self acceptWithValue:value];
    }
}

- (void)declineWithError:(nonnull NSError *)error
{
    if (self.delegate)
    {
        [self.delegate confirmation:self declineWithError:error];
    }
}

- (void)confirmWithError:(nullable NSError *)error
{
    if (error)
    {
        [self declineWithError:error];
    }
    else
    {
        [self accept];
    }
}

@end
