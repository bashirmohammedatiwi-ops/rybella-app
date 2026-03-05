import 'package:cosmatic_app/core/constants/api_constants.dart';

/// Builds image URL using API storage endpoint (CORS-enabled for Flutter web).
String buildImageUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  String relativePath = path;
  if (path.startsWith('http')) {
    final match = RegExp(r'/storage/(.+)$').firstMatch(path);
    relativePath = match != null ? match.group(1)! : path;
  } else if (path.startsWith('storage/')) {
    relativePath = path.replaceFirst('storage/', '');
  }
  return '${ApiConstants.storageApiBase}/$relativePath';
}
