//import 'dart:html';

import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
//https://pub.dev/packages/web3dart
import 'package:http/http.dart'; //You can also import the browser version

//

abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
}

class WalletAddress implements WalletAddressService {
  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(master.key);
    return privateKey;
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    // ignore: avoid_print
    print('address: $address');
    return address;
  }

  //@override
  Future<void> getEthBalance(String privateKey) async {
    var apiUrl =
        "https://polygon-mainnet.infura.io/v3/4d9379f9b09f49aebab793fd5204a96e"; //Replace with your API

    var httpClient = Client();
    var ethClient = Web3Client(apiUrl, httpClient);
    // ignore: avoid_print
    print(ethClient);

    var temp = EthPrivateKey.fromHex(privateKey);
    var credentials = temp.address;

    // You can now call rpc methods. This one will query the amount of Ether you own
    Future<EtherAmount> balance = ethClient.eth_getBalance(credentials);
    // ignore: avoid_print
    print(balance);
  }
}
