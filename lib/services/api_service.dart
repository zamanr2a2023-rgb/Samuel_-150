import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:programmit_app/core/constants/api_endpoints.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/features/events/data/models/event.dart';

class ApiService {
  static String get baseUrl => ApiEndpoints.jsonBaseUrl;

  static Future<List<Event>> fetchEventsByLocation({
    required double lat,
    required double lng,
  }) async {
    final url = '$baseUrl/programLocation.php?lat=$lat&lng=$lng';
    appLog('events: GET $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timed out'),
      );

      appLog(
        'events: ${response.statusCode}, '
        '${response.body.length} bytes',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load events: ${response.statusCode}');
      }

      final dynamic jsonData = json.decode(response.body);
      final List<dynamic> jsonList;
      if (jsonData is List) {
        jsonList = jsonData;
      } else if (jsonData is Map) {
        jsonList = jsonData['data'] as List? ?? [];
      } else {
        throw Exception('Unexpected JSON format');
      }

      final events = jsonList
          .map((json) => Event.fromJson(json as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.distance.compareTo(b.distance));

      appLog('events: parsed ${events.length} rows');
      return events;
    } catch (e, st) {
      appLog('events: fetchEventsByLocation failed: $e\n$st');
      throw Exception('Could not fetch events: $e');
    }
  }

  static Future<List<Event>> searchByCode({
    required String code,
    required double lat,
    required double lng,
  }) async {
    try {
      final allEvents = await fetchEventsByLocation(lat: lat, lng: lng);
      final needle = code.toLowerCase();
      final results = allEvents
          .where((event) => event.kode.toLowerCase().contains(needle))
          .toList();
      appLog('events: code search "$code" → ${results.length} hits');
      return results;
    } catch (e, st) {
      appLog('events: searchByCode failed: $e\n$st');
      throw Exception('Could not search events: $e');
    }
  }

  static Future<List<Event>> fetchNearbyEvents({
    required double lat,
    required double lng,
  }) async {
    try {
      final events = await fetchEventsByLocation(lat: lat, lng: lng);
      final nearby =
          events.where((event) => event.distance <= 2.0).toList();
      appLog('events: within 2km → ${nearby.length}');
      return nearby;
    } catch (e, st) {
      appLog('events: fetchNearbyEvents failed: $e\n$st');
      throw Exception('Could not fetch nearby events: $e');
    }
  }
}
