//
//  BiometricMain.m
//  BioMetric
//
//  Created by Ramees P on 12/09/24.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(BiometricModule,NSObject)
RCT_EXTERN_METHOD(authenticateWithBiometrics:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
@end
