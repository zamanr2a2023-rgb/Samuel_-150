import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:programmit_app/core/constants/app_colors.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/core/widgets/loading_widget.dart';
import 'package:programmit_app/features/events/data/models/event.dart';
import 'package:programmit_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.event});

  final Event event;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  var _markers = <Marker>{};
  var _polylines = <Polyline>{};
  var _isLoading = true;
  String? _distance;
  String? _duration;

  double get _venueLat => double.parse(widget.event.lat);
  double get _venueLng => double.parse(widget.event.longi);

  @override
  void initState() {
    super.initState();
    unawaited(_initializeMap());
  }

  Future<void> _initializeMap() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      setState(() => _currentPosition = position);
      _setMarkers();
      _calculateRoute();
      if (mounted) setState(() => _isLoading = false);
    } catch (e, st) {
      appLog('map: location failed: $e\n$st');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setMarkers() {
    if (!mounted) return;

    final destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(_venueLat, _venueLng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow: InfoWindow(
        title: widget.event.address,
        snippet: widget.event.isMatch
            ? '${widget.event.homeTeamText} vs ${widget.event.awayTeamText}'
            : widget.event.name,
      ),
    );

    if (_currentPosition != null) {
      final currentMarker = Marker(
        markerId: const MarkerId('current'),
        position: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: AppLocalizations.of(context).mapYourPosition,
        ),
      );
      setState(() => _markers = {destinationMarker, currentMarker});
    } else {
      setState(() => _markers = {destinationMarker});
    }
  }

  void _calculateRoute() {
    final pos = _currentPosition;
    if (pos == null) return;

    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: [
        LatLng(pos.latitude, pos.longitude),
        LatLng(_venueLat, _venueLng),
      ],
      color: AppColors.mapRoute,
      width: 5,
    );

    setState(() => _polylines = {polyline});

    final distanceM = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      _venueLat,
      _venueLng,
    );
    final distanceKm = distanceM / 1000;
    const avgKmh = 30.0;
    final durationMin = (distanceKm / avgKmh) * 60;

    setState(() {
      _distance = distanceKm < 1
          ? '${distanceM.toStringAsFixed(0)} m'
          : '${distanceKm.toStringAsFixed(1)} km';
      _duration = durationMin < 1
          ? '< 1 min'
          : '${durationMin.toStringAsFixed(0)} min';
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    final pos = _currentPosition;
    if (pos == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        pos.latitude < _venueLat ? pos.latitude : _venueLat,
        pos.longitude < _venueLng ? pos.longitude : _venueLng,
      ),
      northeast: LatLng(
        pos.latitude > _venueLat ? pos.latitude : _venueLat,
        pos.longitude > _venueLng ? pos.longitude : _venueLng,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () async {
      if (!mounted) return;
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    });
  }

  Future<void> _openGoogleMapsNavigation() async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${widget.event.lat},${widget.event.longi}'
      '&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(l10n.mapDirectionsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigation_rounded),
            onPressed: _openGoogleMapsNavigation,
            tooltip: l10n.mapStartNavTooltip,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          )
                        : LatLng(_venueLat, _venueLng),
                    zoom: 14,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                ),
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
                          color: Colors.black.withValues(alpha: 0.2),
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
                              color: AppColors.primary,
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
                                      color: AppColors.scaffold,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _transportChip(
                              Icons.directions_car,
                              l10n.mapTransportCar,
                              selected: true,
                            ),
                            _transportChip(
                              Icons.directions_walk,
                              l10n.mapTransportWalk,
                              selected: false,
                            ),
                            _transportChip(
                              Icons.directions_bus,
                              l10n.mapTransportBus,
                              selected: false,
                            ),
                            _transportChip(
                              Icons.directions_bike,
                              l10n.mapTransportBike,
                              selected: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton.icon(
                    onPressed: _openGoogleMapsNavigation,
                    icon: const Icon(Icons.navigation, size: 24),
                    label: Text(
                      l10n.mapStartNavigation,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mapRoute,
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

  Widget _transportChip(IconData icon, String label, {required bool selected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.mapRoute : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: selected ? Colors.white : Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.grey[700],
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
