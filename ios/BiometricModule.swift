import Foundation
import LocalAuthentication
import React

@objc(BiometricModule)
class BiometricModule: NSObject {

  @objc
  func authenticateWithBiometrics(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let context = LAContext()
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
            switch laError.code {
            case .authenticationFailed:
              reject("AUTH_FAILED", NSLocalizedString("Authentication failed. Please try again.", comment: ""), laError)
            case .userCancel:
              reject("USER_CANCEL", NSLocalizedString("Authentication was canceled by the user.", comment: ""), laError)
            case .userFallback:
              // The user selects to enter the passcode, system will handle it automatically
              reject("USER_FALLBACK", NSLocalizedString("Fallback to passcode requested by the user.", comment: ""), laError)
            case .systemCancel:
              reject("SYSTEM_CANCEL", NSLocalizedString("Authentication was canceled by the system.", comment: ""), laError)
            case .biometryNotAvailable:
              reject("BIOMETRY_NOT_AVAILABLE", NSLocalizedString("Biometric authentication is not available on this device.", comment: ""), laError)
            case .biometryNotEnrolled:
              reject("BIOMETRY_NOT_ENROLLED", NSLocalizedString("No biometric authentication data is enrolled.", comment: ""), laError)
            case .biometryLockout:
              // If biometric is locked out, automatically show passcode screen
              reject("BIOMETRY_LOCKOUT", NSLocalizedString("Biometric authentication is locked. Use passcode.", comment: ""), laError)
            default:
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
