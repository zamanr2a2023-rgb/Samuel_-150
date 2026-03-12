import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class ApiService {
  static const String baseUrl = 'https://www.programmit.no/json';

  /// Hent events basert på GPS koordinater (Laravel backend)
  static Future<List<Event>> fetchEventsByLocation({
    required double lat,
    required double lng,
  }) async {
    try {
      final url = '$baseUrl/programLocation.php?lat=$lat&lng=$lng';

      print(' Fetching from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      print(' Response status: ${response.statusCode}');
      print(' Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);

        // Handle both array and object responses
        List<dynamic> jsonList;
        if (jsonData is List) {
          jsonList = jsonData;
        } else if (jsonData is Map) {
          // If it's an object with a 'data' field
          jsonList = jsonData['data'] as List? ?? [];
        } else {
          throw Exception('Unexpected JSON format');
        }

        print(' Fetched ${jsonList.length} events');

        List<Event> events = jsonList
            .map((json) => Event.fromJson(json as Map<String, dynamic>))
            .toList();

        // Sort by distance (closest first)
        events.sort((a, b) => a.distance.compareTo(b.distance));

        return events;
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print(' Error fetching events: $e');
      throw Exception('Could not fetch events: $e');
    }
  }

  /// Søk etter events med kode (lokalt filter)
  static Future<List<Event>> searchByCode({
    required String code,
    required double lat,
    required double lng,
  }) async {
    try {
      // Fetch all events first
      List<Event> allEvents = await fetchEventsByLocation(
        lat: lat,
        lng: lng,
      );

      // Filter locally by code
      List<Event> results = allEvents
          .where(
              (event) => event.kode.toLowerCase().contains(code.toLowerCase()))
          .toList();

      print(' Found ${results.length} events with code: $code');

      return results;
    } catch (e) {
      print(' Error searching by code: $e');
      throw Exception('Could not search events: $e');
    }
  }

  /// Hent alle events innen 2km radius (backend beregner avstand)
  static Future<List<Event>> fetchNearbyEvents({
    required double lat,
    required double lng,
  }) async {
    try {
      List<Event> events = await fetchEventsByLocation(
        lat: lat,
        lng: lng,
      );

      // Backend allerede filtrerer til 2km, men vi kan filtrere ekstra her
      List<Event> nearbyEvents =
          events.where((event) => event.distance <= 2.0).toList();

      print(' Found ${nearbyEvents.length} events within 2km');

      return nearbyEvents;
    } catch (e) {
      print(' Error fetching nearby events: $e');
      throw Exception('Could not fetch nearby events: $e');
    }
  }
}
