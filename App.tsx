import React, { useState } from 'react';
import { View, Button, Text, Alert, StyleSheet } from 'react-native';
import { authenticateWithBiometrics } from './src/native-modules/bridge-modules';

const App = () => {
  const [authenticated, setAuthenticated] = useState(false);

  const handleAuthentication = async () => {
    try {
      const success = await authenticateWithBiometrics();
      console.log(success,'success');
      if (success) {
        setAuthenticated(success);
        Alert.alert('Success', 'Authentication successful!');
      }
     else {
        setAuthenticated(success);
        Alert.alert('Error', 'Authentication failed!');
      }
    } catch (error: any) {
      console.log(error);
      
      Alert.alert('Error', error.message);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.status}>
        {authenticated ? 'Authenticated' : 'Not Authenticated'}
      </Text>
      <Button title="Authenticate with Biometrics" onPress={handleAuthentication} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  status: {
    marginBottom: 20,
    fontSize: 18,
  },
});

export default App;
