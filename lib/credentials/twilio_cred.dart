import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TwilioCred{
  final FlutterSecureStorage flutterSecureStorage= const FlutterSecureStorage();
  writeCred() async{
    await flutterSecureStorage.write(key: 'twilioAccountSid', value: 'AC86ce41bcc4825bd595bb91a30bff4074');
    await flutterSecureStorage.write(key: 'twilioAuthToken', value: 'cffd898c697a4bd0ecaacdec0e9efb52');
    await flutterSecureStorage.write(key: 'twilioNumber', value: '+13106607395');
  }
  readCred() async{
    String? twilioAccountSid= await flutterSecureStorage.read(key: 'twilioAccountSid');
    String? twilioAuthToken= await flutterSecureStorage.read(key: 'twilioAuthToken');
    String? twilioNumber= await flutterSecureStorage.read(key: 'twilioNumber');
    return [twilioAccountSid, twilioAuthToken, twilioNumber];
  }
}