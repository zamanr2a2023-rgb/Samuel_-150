import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:programmit_app/core/constants/api_endpoints.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/features/events/data/models/event.dart';

List<dynamic> _jsonRootToList(dynamic root) {
  if (root is List<dynamic>) return root;
  if (root is Map) {
    return root['data'] as List<dynamic>? ?? const [];
  }
  throw const FormatException('JSON root must be a list or map');
}

class ApiService {
  ApiService._();

  static String get baseUrl => ApiEndpoints.jsonBaseUrl;

  static Future<List<Event>> fetchEventsByLocation({
    required double lat,
    required double lng,
  }) async {
    final url = '$baseUrl/programLocation.php?lat=$lat&lng=$lng';
    appLog('events GET $url');

    try {
      final response = await http
          .get(
            Uri.parse(url),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Request timed out'),
          );

      appLog('events ${response.statusCode} (${response.body.length}b)');

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final raw = json.decode(response.body);
      final rows = _jsonRootToList(raw);
      final events = rows
          .map((row) => Event.fromJson(row as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.distance.compareTo(b.distance));

      appLog('events parsed ${events.length}');
      return events;
    } catch (e, st) {
      appLog('events fetch: $e\n$st');
      throw Exception('Could not fetch events: $e');
    }
  }

  static Future<List<Event>> searchByCode({
    required String code,
    required double lat,
    required double lng,
  }) async {
    try {
      final all = await fetchEventsByLocation(lat: lat, lng: lng);
      final needle = code.toLowerCase();
      final hits =
          all.where((e) => e.kode.toLowerCase().contains(needle)).toList();
      appLog('events code "$code" → ${hits.length}');
      return hits;
    } catch (e, st) {
      appLog('events code search: $e\n$st');
      throw Exception('Could not search events: $e');
    }
  }

  static Future<List<Event>> fetchNearbyEvents({
    required double lat,
    required double lng,
  }) async {
    try {
      final events = await fetchEventsByLocation(lat: lat, lng: lng);
      final nearby = events.where((e) => e.distance <= 2.0).toList();
      appLog('events ≤2km: ${nearby.length}');
      return nearby;
    } catch (e, st) {
      appLog('events nearby: $e\n$st');
      throw Exception('Could not fetch nearby events: $e');
    }
  }
}
