import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TwilioCred{
  final FlutterSecureStorage flutterSecureStorage= const FlutterSecureStorage();
  writeCred() async{
    await flutterSecureStorage.write(key: 'twilioAccountSid', value: 'dcghnm');
    await flutterSecureStorage.write(key: 'twilioAuthToken', value: 'gyhnm');
    await flutterSecureStorage.write(key: 'twilioNumber', value: '+erghgr');
  }
  readCred() async{
    String? twilioAccountSid= await flutterSecureStorage.read(key: 'twilioAccountSid');
    String? twilioAuthToken= await flutterSecureStorage.read(key: 'twilioAuthToken');
    String? twilioNumber= await flutterSecureStorage.read(key: 'twilioNumber');
    return [twilioAccountSid, twilioAuthToken, twilioNumber];
  }
}
