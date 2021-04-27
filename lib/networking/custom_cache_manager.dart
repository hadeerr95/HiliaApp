import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'api_provider..dart';

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(seconds: 20),
      maxNrOfCacheObjects: 2000,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: CustomHttpFileService(),
    ),
  );
}

class CustomHttpFileService extends FileService {
  // http.Client _httpClient;
  // ApiProvider _apiProvider;
  // CustomHttpFileService({ApiProvider apiProvider}) {
  //   _apiProvider = apiProvider ?? ApiProvider();
  // }

  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String> headers = const {}}) async {
    ApiProvider _apiProvider = await ApiProvider.instance;
    final httpResponse = await _apiProvider.fetch(url, headers: headers);

    return HttpGetResponse(httpResponse);
  }
}

// class HttpGetResponse implements FileServiceResponse {
//   HttpGetResponse(this._response);

//   final DateTime _receivedTime = clock.now();

//   final http.StreamedResponse _response;

//   @override
//   int get statusCode => _response.statusCode;

//   bool _hasHeader(String name) {
//     return _response.headers.containsKey(name);
//   }

//   String _header(String name) {
//     return _response.headers[name];
//   }

//   @override
//   Stream<List<int>> get content => _response.stream;

//   @override
//   int get contentLength => _response.contentLength;

//   @override
//   DateTime get validTill {
//     // Without a cache-control header we keep the file for a week
//     var ageDuration = const Duration(days: 7);
//     if (_hasHeader(HttpHeaders.cacheControlHeader)) {
//       final controlSettings =
//           _header(HttpHeaders.cacheControlHeader).split(',');
//       for (final setting in controlSettings) {
//         final sanitizedSetting = setting.trim().toLowerCase();
//         if (sanitizedSetting == 'no-cache') {
//           ageDuration = const Duration();
//         }
//         if (sanitizedSetting.startsWith('max-age=')) {
//           var validSeconds = int.tryParse(sanitizedSetting.split('=')[1]) ?? 0;
//           if (validSeconds > 0) {
//             ageDuration = Duration(seconds: validSeconds);
//           }
//         }
//       }
//     }

//     return _receivedTime.add(ageDuration);
//   }

//   @override
//   String get eTag => _hasHeader(HttpHeaders.etagHeader)
//       ? _header(HttpHeaders.etagHeader)
//       : null;

//   @override
//   String get fileExtension {
//     var fileExtension = '';
//     if (_hasHeader(HttpHeaders.contentTypeHeader)) {
//       var contentType =
//           ContentType.parse(_header(HttpHeaders.contentTypeHeader));
//       fileExtension = contentType.fileExtension ?? '';
//     }
//     return fileExtension;
//   }
// }
