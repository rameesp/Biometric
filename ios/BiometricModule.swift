import Foundation
import LocalAuthentication
import React

@objc(BiometricModule)
class BiometricModule: NSObject {
  private let context = LAContext()

  @objc
  func authenticateWithBiometrics(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    var error: NSError?

    // Check if the device supports biometrics or passcode
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
      let reason = NSLocalizedString("Authenticate using Face ID, Touch ID, or passcode", comment: "Authentication reason")

      // Evaluate the deviceOwnerAuthentication policy, which supports both biometrics and passcode
      context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
        DispatchQueue.main.async {
          if success {
            resolve(true)
          } else if let laError = authenticationError as? LAError {
            let errorMap: [LAError.Code: (String, String)] = [
              .authenticationFailed: ("AUTH_FAILED", NSLocalizedString("Authentication failed. Please try again.", comment: "")),
              .userCancel: ("USER_CANCEL", NSLocalizedString("Authentication was canceled by the user.", comment: "")),
              .userFallback: ("USER_FALLBACK", NSLocalizedString("Fallback to passcode requested by the user.", comment: "")),
              .systemCancel: ("SYSTEM_CANCEL", NSLocalizedString("Authentication was canceled by the system.", comment: "")),
              .biometryNotAvailable: ("BIOMETRY_NOT_AVAILABLE", NSLocalizedString("Biometric authentication is not available on this device.", comment: "")),
              .biometryNotEnrolled: ("BIOMETRY_NOT_ENROLLED", NSLocalizedString("No biometric authentication data is enrolled.", comment: "")),
              .biometryLockout: ("BIOMETRY_LOCKOUT", NSLocalizedString("Biometric authentication is locked. Use passcode.", comment: "")),
            ]

            if let (errorCode, errorMessage) = errorMap[laError.code] {
              reject(errorCode, errorMessage, laError)
            } else {
              reject("UNKNOWN_ERROR", NSLocalizedString("An unknown error occurred.", comment: ""), laError)
            }
          } else if let error = authenticationError {
            reject("UNKNOWN_ERROR", NSLocalizedString("An unknown error occurred.", comment: ""), error)
          }
        }
      }
    } else {
      // If neither biometrics nor passcode is available
      DispatchQueue.main.async {
        reject("NO_AUTH_AVAILABLE", NSLocalizedString("No authentication method available.", comment: ""), error)
      }
    }
  }
}

// Extension to register the module with React Native
extension BiometricModule: RCTBridgeModule {
  static func moduleName() -> String! {
    return "BiometricModule"
  }
}
