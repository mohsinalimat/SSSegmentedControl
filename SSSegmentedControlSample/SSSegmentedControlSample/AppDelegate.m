//
//  AppDelegate.m
//
//  Copyright (c) 2014 StyleShare (https://stylesha.re)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "AppDelegate.h"
#import "SSSegmentedControl.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // no customization (use tint color for default)
    [self createNotCustomizedSample];
    
    // tint color
    [self createTintColorCustomizedSample];
    
    // border width
    // corner radius
    // border color
    // background color
    [self createFullyCustomizedSample];
    
    return YES;
}

- (void)createNotCustomizedSample
{
    SSSegmentedControl *control = [[SSSegmentedControl alloc] initWithItems:@[@"Item A", @"Item B", @"Item C"]];
    control.frame = CGRectMake(60, 40, 200, 30);
    [self.window addSubview:control];
}

- (void)createTintColorCustomizedSample
{
    SSSegmentedControl *control = [[SSSegmentedControl alloc] initWithItems:@[@"Item A", @"Item B", @"Item C"]];
    control.frame = CGRectMake(60, 80, 200, 30);
    control.tintColor = [UIColor redColor];
    [self.window addSubview:control];
}

- (void)createFullyCustomizedSample
{
    SSSegmentedControl *control = [[SSSegmentedControl alloc] initWithItems:@[@"Item A", @"Item B", @"Item C"]];
    control.frame = CGRectMake(60, 120, 200, 30);
    control.borderWidth = 0.5;
    control.cornerRadius = 3;
    
    [control setBorderColor:[UIColor colorWithWhite:204 / 255.0 alpha:1] forState:UIControlStateNormal];
    [control setBorderColor:[UIColor colorWithWhite:204 / 255.0 alpha:1] forState:UIControlStateHighlighted];
    [control setBorderColor:[UIColor colorWithWhite:87 / 255.0 alpha:1] forState:UIControlStateSelected];
    
    [control setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [control setBackgroundColor:[UIColor colorWithWhite:242 / 255.0 alpha:1] forState:UIControlStateHighlighted];
    [control setBackgroundColor:[UIColor colorWithWhite:103 / 255.0 alpha:1] forState:UIControlStateSelected];
    
    [control setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:128 / 255.0 alpha:1],
                                      NSFontAttributeName: [UIFont systemFontOfSize:12]}
                           forState:UIControlStateNormal];
    
    [self.window addSubview:control];
}

@end
