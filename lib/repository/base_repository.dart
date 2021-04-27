import 'dart:async';
import 'dart:convert';

import 'package:app/graphql/graphql.dart';

abstract class BaseRepository {
  Stream<T> streamHandler<T>(Stream<T> stream) async* {
    // ignore: close_sinks
    StreamController<T> controller = StreamController<T>();
    stream.listen((event) {
      controller.add(event);
    }, onError: (e) {
      // print("-------------------------------");
      // print("${e.runtimeType}: $e");
      // print("-------------------------------");
    }, onDone: () {});
    yield* controller.stream;
  }

  // Stream<dynamic> fetchFileStream(url) async* {
  //   // yield* fetchDownloadFile(url);
  //   var file = CustomCacheManager.instance.getFileStream(url + "&lang=$_lang");
  //   yield* file.asyncMap((event) async {
  //     if (event is FileInfo) {
  //       if (event.file != null && await event.file.exists()) {
  //         String resString = await event.file.readAsString();
  //         return json.decode(resString)['data'];
  //       }
  //     }
  //     return null;
  //   });
  // }

  // Stream<dynamic> fetchDownloadFile(url) async* {
  //   var file =
  //       await CustomCacheManager.instance.downloadFile(url + "&lang=$_lang");
  //   if (await file.file.exists()) {
  //     String resString = await file.file.readAsString();
  //     yield json.decode(resString)['data'];
  //   }
  // }

  Future<dynamic> fetchFileFromCache(BaseQuery query) async {
    var fileInfo =
        await GraphQLCacheManager.instance.getFileFromCache(query.toString());
    var file = fileInfo?.file;
    if ((await file?.exists()) ?? false)
      return json.decode(await file.readAsString());
  }

  Future<dynamic> fetchFileFromInternet(BaseQuery query) async {
    var fileInfo =
        await GraphQLCacheManager.instance.downloadFile(query.toString());
    // print("\n.\n..\n.\n..\n.\n..\n.\n..\n.\n..\n.\n..\n.\n..\n.\n..\n");
    var file = fileInfo.file;
    // print((await file?.readAsString()) ?? "---");
    if ((await file?.exists()) ?? false)
      return jsonDecode(await file.readAsString());
  }

  Stream<FetchData> fetchfirstFromCache(BaseQuery query) async* {
    try {
      var data = await fetchFileFromCache(query);
      // print("Cache: $data");
      if (data != null) yield FetchDataFromCache(data["viewer"]);
    } catch (e) {
      print("Ex-fetchfirstFromCache, Cache: $e");
    } finally {
      var data = await fetchFileFromInternet(query);
      // print("Internet: $data");
      if (data != null) yield FetchDataFromInternet(data["viewer"]);
    }
  }
}

abstract class FetchData {
  final data;

  FetchData(this.data);
}

class FetchDataFromCache extends FetchData {
  FetchDataFromCache(data) : super(data);
}

class FetchDataFromInternet extends FetchData {
  FetchDataFromInternet(data) : super(data);
}
