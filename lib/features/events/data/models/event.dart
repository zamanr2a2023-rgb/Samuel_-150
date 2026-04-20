class Event {
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

  final String id;
  final String userId;
  final String name;

  final String cell;
  final String address;

  final String homeTeam;
  final String awayTeam;
  final String homeTeamText;
  final String awayTeamText;

  final String lat;
  final String longi;

  final String dag;
  final String tid;
  final String pdfPath;
  final String kode;
  final double distance;

  static const _monthAbbrev = [
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
    'des',
  ];

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

  String get displayName =>
      isMatch ? '$homeTeamText vs $awayTeamText' : name;

  String get formattedDistance {
    if (distance == 0) return '';
    return '${distance.toStringAsFixed(1)} km';
  }

  String get formattedDateTime {
    try {
      final dateTime = DateTime.parse('$dag $tid:00');
      return '${dateTime.day}. ${_monthAbbrev[dateTime.month]} '
          '${dateTime.year}, $tid';
    } catch (_) {
      return '$dag, $tid';
    }
  }

  String get fullImageUrl =>
      homeTeam.startsWith('http') ? homeTeam : 'https://www.programmit.no/$homeTeam';

  String get awayTeamImageUrl =>
      awayTeam.startsWith('http') ? awayTeam : 'https://www.programmit.no/$awayTeam';

  String get fullPdfUrl {
    if (pdfPath.isEmpty) return '';
    if (pdfPath.startsWith('http')) return pdfPath;
    return 'https://www.programmit.no/data/$pdfPath';
  }

  String get mapsUrl =>
      'https://www.google.com/maps/search/?api=1&query=$lat,$longi';
}
