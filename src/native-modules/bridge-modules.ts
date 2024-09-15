import { NativeModules, Platform } from 'react-native';

const { BiometricModule } = NativeModules;
console.log(NativeModules,'NativeModules');

export const authenticateWithBiometrics = (): Promise<boolean> => {
  if (Platform.OS !== 'ios') {
    return Promise.reject(new Error('Biometric authentication is only available on iOS'));
  }
  return BiometricModule.authenticateWithBiometrics();
};
