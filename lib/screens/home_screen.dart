import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/event.dart';
import '../services/api_service.dart';
import '../widgets/match_card.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _codeController = TextEditingController();

  List<Event> events = [];
  bool isLoading = false;
  String errorMessage = '';
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'GPS er ikke aktivert';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = 'GPS-tillatelse nektet';
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Kunne ikke hente GPS-posisjon: $e';
      });
    }
  }

  Future<void> _searchByLocation() async {
    if (currentPosition == null) {
      await _getCurrentLocation();
      if (currentPosition == null) {
        _showSnackBar('Kunne ikke hente GPS-posisjon', Colors.red);
        return;
      }
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
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
        _showSnackBar('Ingen kamper funnet i nærheten', Colors.orange);
      } else {
        _showSnackBar('Fant ${fetchedEvents.length} kampprogram', Colors.green);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Søk feilet: $e';
      });
      _showSnackBar('Søk feilet: $e', Colors.red);
    }
  }

  Future<void> _searchByCode() async {
    String code = _codeController.text.trim();
    if (code.isEmpty) {
      _showSnackBar('Vennligst skriv inn en kode', Colors.orange);
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
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
        _showSnackBar('Ingen kamper funnet med kode: ${_codeController.text}',
            Colors.orange);
      } else {
        _showSnackBar('Fant ${results.length} kampprogram', Colors.green);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Søk feilet: $e';
      });
      _showSnackBar('Søk feilet: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      body: SafeArea(
        child: Column(
          children: [
            // PROGRAMMIT LOGO - STØRRE OG KANT-TIL-KANT!
            Container(
              width: double.infinity,
              height: 200, // STØRRE! (var 180)
              color: Color(0xFF2C3E50),
              padding: EdgeInsets.zero, // INGEN PADDING - dekker alt!
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover, // Dekker hele området!
                errorBuilder: (context, error, stackTrace) {
                  print(' Logo asset error: $error');
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Color(0xFF2C3E50),
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sports_soccer,
                                size: 50, color: Colors.white),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFF27AE60),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.calendar_today,
                                  size: 40, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.sports_basketball,
                                size: 50, color: Colors.orange),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'ProgramIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF1E5BA8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'KAMPPROGRAM',
                            style: TextStyle(
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

            // Orange header - MINDRE!
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10), // MINDRE! (var 14)
              decoration: BoxDecoration(
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
                  // Kode-søk - MINDRE!
                  TextField(
                    controller: _codeController,
                    style: TextStyle(color: Color(0xFF2C3E50), fontSize: 14),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'skriv inn kode',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onSubmitted: (_) => _searchByCode(),
                  ),

                  SizedBox(height: 8), // MINDRE! (var 12)

                  // Knapper - MINDRE!
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _searchByCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2C3E50),
                            foregroundColor: Colors.white,
                            minimumSize: Size(0, 42), // MINDRE! (var 46)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Søk på kode',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _searchByLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2C3E50),
                            foregroundColor: Colors.white,
                            minimumSize: Size(0, 42), // MINDRE! (var 46)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Søk i nærheten',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8), // MINDRE! (var 12)

                  // FACEBOOK IKON - MINDRE!
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
                                content:
                                    Text('Kunne ikke åpne Facebook-gruppe'),
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
                              content: Text('Kunne ikke åpne Facebook-gruppe'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 52, // MINDRE! (var 60)
                      height: 52, // MINDRE! (var 60)
                      decoration: BoxDecoration(
                        color: Color(0xFF1877F2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'f',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38, // MINDRE! (var 42)
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

            // Results
            if (isLoading)
              Expanded(
                child: Center(
                  child: SpinKitCircle(
                    color: Color(0xFFFF8C42),
                    size: 60.0,
                  ),
                ),
              )
            else if (errorMessage.isNotEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
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
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.white38,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Søk etter kamper med kode eller GPS',
                        style: TextStyle(
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
                  padding: EdgeInsets.all(16),
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
