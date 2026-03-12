import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../models/event.dart';

class MapScreen extends StatefulWidget {
  final Event event;

  const MapScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;
  String? _distance;
  String? _duration;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      // Hent brukerens posisjon
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Sett markers
      _setMarkers();

      // Beregn rute (simulert - du kan bruke Google Directions API for ekte rute)
      _calculateRoute();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(' Error getting location: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setMarkers() {
    // Destinasjon marker (arena)
    final destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(
        double.parse(widget.event.lat),
        double.parse(widget.event.longi),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(
        title: widget.event.address,
        snippet: widget.event.isMatch
            ? '${widget.event.homeTeamText} vs ${widget.event.awayTeamText}'
            : widget.event.name,
      ),
    );

    // Brukerens posisjon marker
    if (_currentPosition != null) {
      final currentMarker = Marker(
        markerId: const MarkerId('current'),
        position:
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Din posisjon',
        ),
      );

      setState(() {
        _markers = {destinationMarker, currentMarker};
      });
    } else {
      setState(() {
        _markers = {destinationMarker};
      });
    }
  }

  void _calculateRoute() {
    if (_currentPosition == null) return;

    // Enkel rett linje (for demo)
    // For ekte veibeskrivelse, bruk Google Directions API
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: [
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        LatLng(
          double.parse(widget.event.lat),
          double.parse(widget.event.longi),
        ),
      ],
      color: const Color(0xFF2196F3),
      width: 5,
    );

    setState(() {
      _polylines = {polyline};
    });

    // Beregn avstand
    _calculateDistance();
  }

  void _calculateDistance() {
    if (_currentPosition == null) return;

    double distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      double.parse(widget.event.lat),
      double.parse(widget.event.longi),
    );

    double distanceInKm = distanceInMeters / 1000;

    // Simulert tid (gjennomsnitt 30 km/t)
    double durationInMinutes = (distanceInKm / 30) * 60;

    setState(() {
      _distance = distanceInKm < 1
          ? '${distanceInMeters.toStringAsFixed(0)} m'
          : '${distanceInKm.toStringAsFixed(1)} km';
      _duration = durationInMinutes < 1
          ? '< 1 min'
          : '${durationInMinutes.toStringAsFixed(0)} min';
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Zoom til å vise begge markere
    if (_currentPosition != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _currentPosition!.latitude < double.parse(widget.event.lat)
              ? _currentPosition!.latitude
              : double.parse(widget.event.lat),
          _currentPosition!.longitude < double.parse(widget.event.longi)
              ? _currentPosition!.longitude
              : double.parse(widget.event.longi),
        ),
        northeast: LatLng(
          _currentPosition!.latitude > double.parse(widget.event.lat)
              ? _currentPosition!.latitude
              : double.parse(widget.event.lat),
          _currentPosition!.longitude > double.parse(widget.event.longi)
              ? _currentPosition!.longitude
              : double.parse(widget.event.longi),
        ),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
      });
    }
  }

  // Åpne Google Maps eksternt for ekte turn-by-turn navigation
  Future<void> _openGoogleMapsNavigation() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${widget.event.lat},${widget.event.longi}&travelmode=driving',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C42),
        title: const Text(
          'Veibeskrivelse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Start navigation i Google Maps app
          IconButton(
            icon: const Icon(Icons.navigation),
            onPressed: _openGoogleMapsNavigation,
            tooltip: 'Start navigasjon',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF8C42),
              ),
            )
          : Stack(
              children: [
                // Google Maps
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude)
                        : LatLng(
                            double.parse(widget.event.lat),
                            double.parse(widget.event.longi),
                          ),
                    zoom: 14,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                ),

                // Info kort øverst (som Ørstein har "Veibeskrivelse" kort)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFFF8C42),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.event.address,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  if (_distance != null && _duration != null)
                                    Text(
                                      '$_duration • $_distance',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Transport valg (som Ørstein)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTransportButton(
                                Icons.directions_car, 'Bil', true),
                            _buildTransportButton(
                                Icons.directions_walk, 'Gå', false),
                            _buildTransportButton(
                                Icons.directions_bus, 'Buss', false),
                            _buildTransportButton(
                                Icons.directions_bike, 'Sykkel', false),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Start navigasjon knapp nederst (som Ørstein)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton.icon(
                    onPressed: _openGoogleMapsNavigation,
                    icon: const Icon(Icons.navigation, size: 24),
                    label: const Text(
                      'START NAVIGASJON',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTransportButton(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2196F3) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
