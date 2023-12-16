import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TwilioCred {
  final FlutterSecureStorage flutterSecureStorage =
      const FlutterSecureStorage();
  writeCred() async {
    await flutterSecureStorage.write(
        key: 'twilioAccountSid', value: 'AC3657367cb3e2e46d3496682634d0e3bd');
    await flutterSecureStorage.write(
        key: 'twilioAuthToken', value: '87b6898958321922f5a32752a34b84ef');
    await flutterSecureStorage.write(
        key: 'twilioNumber', value: '+12057934634');
  }

  readCred() async {
    String? twilioAccountSid =
        await flutterSecureStorage.read(key: 'twilioAccountSid');
    String? twilioAuthToken =
        await flutterSecureStorage.read(key: 'twilioAuthToken');
    String? twilioNumber = await flutterSecureStorage.read(key: 'twilioNumber');
    return [twilioAccountSid, twilioAuthToken, twilioNumber];
  }
}