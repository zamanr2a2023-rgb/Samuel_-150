import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import '../widgets/match_card.dart';
import '../widgets/event_card.dart';
import '../l10n/app_localizations.dart';
import '../app_locale.dart';

/// Persistent GPS / search error shown in the main panel (re-resolves on locale change).
enum _HomePanelError {
  none,
  gpsDisabled,
  gpsPermissionDenied,
  gpsPositionFailed,
  searchFailed,
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _codeController = TextEditingController();

  List<Event> events = [];
  bool isLoading = false;
  _HomePanelError panelError = _HomePanelError.none;
  String panelErrorDetail = '';
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  String _panelErrorText(AppLocalizations l10n) {
    switch (panelError) {
      case _HomePanelError.none:
        return '';
      case _HomePanelError.gpsDisabled:
        return l10n.errorGpsDisabled;
      case _HomePanelError.gpsPermissionDenied:
        return l10n.errorGpsPermissionDenied;
      case _HomePanelError.gpsPositionFailed:
        return l10n.errorGpsPosition(panelErrorDetail);
      case _HomePanelError.searchFailed:
        return l10n.snackSearchFailed(panelErrorDetail);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          panelError = _HomePanelError.gpsDisabled;
          panelErrorDetail = '';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            panelError = _HomePanelError.gpsPermissionDenied;
            panelErrorDetail = '';
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        currentPosition = position;
        panelError = _HomePanelError.none;
        panelErrorDetail = '';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        panelError = _HomePanelError.gpsPositionFailed;
        panelErrorDetail = e.toString();
      });
    }
  }

  Future<void> _searchByLocation() async {
    final l10n = AppLocalizations.of(context);
    if (currentPosition == null) {
      await _getCurrentLocation();
      if (currentPosition == null) {
        _showSnackBar(l10n.snackNoGps, Colors.red);
        return;
      }
    }

    setState(() {
      isLoading = true;
      panelError = _HomePanelError.none;
      panelErrorDetail = '';
    });

    try {
      List<Event> fetchedEvents = await ApiService.fetchNearbyEvents(
        lat: currentPosition!.latitude,
        lng: currentPosition!.longitude,
      );

      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });

      if (fetchedEvents.isEmpty) {
        _showSnackBar(l10n.snackNoMatchesNearby, Colors.orange);
      } else {
        _showSnackBar(
            l10n.snackFoundSchedules(fetchedEvents.length), Colors.green);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        panelError = _HomePanelError.searchFailed;
        panelErrorDetail = e.toString();
      });
      _showSnackBar(l10n.snackSearchFailed(e.toString()), Colors.red);
    }
  }

  Future<void> _searchByCode() async {
    final l10n = AppLocalizations.of(context);
    String code = _codeController.text.trim();
    if (code.isEmpty) {
      _showSnackBar(l10n.snackEnterCode, Colors.orange);
      return;
    }

    setState(() {
      isLoading = true;
      panelError = _HomePanelError.none;
      panelErrorDetail = '';
    });

    try {
      List<Event> results = await ApiService.searchByCode(
        code: code,
        lat: currentPosition?.latitude ?? 0.0,
        lng: currentPosition?.longitude ?? 0.0,
      );

      setState(() {
        events = results;
        isLoading = false;
      });

      if (results.isEmpty) {
        _showSnackBar(l10n.snackNoMatchesForCode(_codeController.text),
            Colors.orange);
      } else {
        _showSnackBar(l10n.snackFoundSchedules(results.length), Colors.green);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        panelError = _HomePanelError.searchFailed;
        panelErrorDetail = e.toString();
      });
      _showSnackBar(l10n.snackSearchFailed(e.toString()), Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _onLanguageSelected(Set<String> selected) async {
    final code = selected.first;
    await saveAppLocale(Locale(code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              child: Row(
                children: [
                  const Spacer(),
                  Tooltip(
                    message: l10n.languageToggleHint,
                    child: SegmentedButton<String>(
                      showSelectedIcon: false,
                      style: SegmentedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        // Same fill for both segments when unselected; orange only for selected.
                        backgroundColor: const Color(0xFF34495E),
                        foregroundColor: Colors.white70,
                        selectedBackgroundColor: const Color(0xFFFF8C42),
                        selectedForegroundColor: const Color(0xFF2C3E50),
                        side: const BorderSide(color: Color(0x44FFFFFF)),
                      ),
                      segments: [
                        ButtonSegment<String>(
                          value: 'en',
                          label: Text(l10n.languageEnglish),
                        ),
                        ButtonSegment<String>(
                          value: 'nb',
                          label: Text(l10n.languageNorwegian),
                        ),
                      ],
                      selected: {langCode == 'en' ? 'en' : 'nb'},
                      onSelectionChanged: _onLanguageSelected,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              color: const Color(0xFF2C3E50),
              padding: EdgeInsets.zero,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print(' Logo asset error: $error');
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: const Color(0xFF2C3E50),
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sports_soccer,
                                size: 50, color: Colors.white),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF27AE60),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.calendar_today,
                                  size: 40, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.sports_basketball,
                                size: 50, color: Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E5BA8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10n.kampprogramSubtitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFFF8C42),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _codeController,
                    style: const TextStyle(
                        color: Color(0xFF2C3E50), fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: l10n.hintEnterCode,
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                    onSubmitted: (_) => _searchByCode(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _searchByCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2C3E50),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l10n.searchByCode,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _searchByLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2C3E50),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l10n.searchNearby,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(
                          'https://www.facebook.com/groups/1310841980973835');
                      try {
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.snackFacebookError),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        print('Feil ved åpning av Facebook: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.snackFacebookError),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1877F2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'f',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: SpinKitCircle(
                    color: Color(0xFFFF8C42),
                    size: 60.0,
                  ),
                ),
              )
            else if (panelError != _HomePanelError.none)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      _panelErrorText(l10n),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else if (events.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.white38,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.emptySearchPrompt,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    Event event = events[index];
                    if (event.isMatch) {
                      return MatchCard(event: event);
                    } else {
                      return EventCard(event: event);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
