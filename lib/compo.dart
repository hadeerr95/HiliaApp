import 'dart:io';

Future<bool> get isConnectivity async {
  if (await isConnectivityByUrl('google.com'))
    return true;
  else if (await isConnectivityByUrl('facebook.com'))
    return true;
  else
    return false;
}

Future<bool> isConnectivityByUrl(String url) async {
  try {
    final result = await InternetAddress.lookup(url);
    if (result.isNotEmpty && (result?.first?.rawAddress?.isNotEmpty ?? false)) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}
