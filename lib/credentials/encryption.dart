import 'package:encrypt/encrypt.dart';

class EncryptionDecryption {
  static final Key key = Key.fromUtf8('152@%6bVji*%@%^hGhJ*&dDHiF)(89s)');
  static final IV iv = IV.fromUtf8('NE284@#H*fj&GWa%');
  static final encrypter = Encrypter(AES(key));

  static encryptAES(text) {
    String _addBase64Padding(String input) {
      while (input.length % 4 != 0) {
        input += '=';
      }
      return input;
    }

    final paddedEncrypted = _addBase64Padding(text);
    final encrypted = encrypter.encrypt(paddedEncrypted, iv: iv);
    final encryptedText = encrypted.base64;
    return encryptedText;
  }

  static decryptAES(text) {
    final decrypted = encrypter.decrypt64(text, iv: iv);
    return decrypted.replaceAll(RegExp('=*\$'), '');
  }

 
  }

