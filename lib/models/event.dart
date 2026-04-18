class Event {
  final String id; // Backend event ID (20, 21, 22, etc.)
  final String userId;
  final String name;
  final String cell; // "MatchCell" or "EventCell"
  final String address;
  final String homeTeam; // Image URL
  final String awayTeam; // Image URL
  final String homeTeamText;
  final String awayTeamText;
  final String lat;
  final String longi;
  final String dag; // Date: "2026-09-03"
  final String tid; // Time: "12:12"
  final String pdfPath;
  final String kode;

  final double distance;

  Event({
    required this.id,
    required this.userId,
    required this.name,
    required this.cell,
    required this.address,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamText,
    required this.awayTeamText,
    required this.lat,
    required this.longi,
    required this.dag,
    required this.tid,
    required this.pdfPath,
    required this.kode,
    required this.distance,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      cell: json['cell'] ?? 'EventCell',
      address: json['address'] ?? '',
      homeTeam: json['homeTeam'] ?? '',
      awayTeam: json['awayTeam'] ?? '',
      homeTeamText: json['homeTeamText'] ?? 'blank',
      awayTeamText: json['awayTeamText'] ?? 'blank',
      lat: json['lat'] ?? '0',
      longi: json['longi'] ?? '0',
      dag: json['dag'] ?? '',
      tid: json['tid'] ?? '',
      pdfPath: json['PDFPath'] ?? '',
      kode: json['kode'] ?? '',
      distance: _parseDistance(json['distance']),
    );
  }

  static double _parseDistance(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  bool get isMatch => cell == 'MatchCell';
  bool get isEvent => cell == 'EventCell';

  String get displayName {
    if (isMatch) {
      return '$homeTeamText vs $awayTeamText';
    }
    return name;
  }

  String get formattedDistance {
    if (distance == 0) return '';
    return '${distance.toStringAsFixed(1)} km';
  }

  String get formattedDateTime {
    try {
      DateTime dateTime = DateTime.parse('$dag $tid:00');
      List<String> months = [
        '',
        'jan',
        'feb',
        'mar',
        'apr',
        'mai',
        'jun',
        'jul',
        'aug',
        'sep',
        'okt',
        'nov',
        'des'
      ];

      return '${dateTime.day}. ${months[dateTime.month]} ${dateTime.year}, $tid';
    } catch (e) {
      return '$dag, $tid';
    }
  }

  String get fullImageUrl {
    if (homeTeam.startsWith('http')) {
      return homeTeam;
    }
    return 'https://www.programmit.no/$homeTeam';
  }

  String get awayTeamImageUrl {
    if (awayTeam.startsWith('http')) {
      return awayTeam;
    }
    return 'https://www.programmit.no/$awayTeam';
  }

  String get fullPdfUrl {
    if (pdfPath.isEmpty) return '';

    if (pdfPath.startsWith('http')) {
      return pdfPath;
    }

    // PDF-filer ligger i data/ mappen på serveren
    return 'https://www.programmit.no/data/$pdfPath';
  }

  String get mapsUrl {
    // Google Maps URL for navigation
    return 'https://www.google.com/maps/search/?api=1&query=$lat,$longi';
  }
}
