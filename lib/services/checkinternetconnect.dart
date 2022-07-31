import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternetConnection() async {
  bool connected = false;
  await Connectivity().checkConnectivity().then((value) {
    if (value == ConnectivityResult.mobile ||
        value == ConnectivityResult.wifi ||
        value == ConnectivityResult.ethernet) {
      connected = true;
    }
  });
  return connected;
}
