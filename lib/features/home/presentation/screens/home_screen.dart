import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:programmit_app/core/constants/app_colors.dart';
import 'package:programmit_app/core/utils/app_log.dart';
import 'package:programmit_app/core/utils/helpers.dart';
import 'package:programmit_app/core/utils/input_checks.dart';
import 'package:programmit_app/core/widgets/loading_widget.dart';
import 'package:programmit_app/features/events/data/models/event.dart';
import 'package:programmit_app/features/home/presentation/widgets/event_card.dart';
import 'package:programmit_app/features/home/presentation/widgets/match_card.dart';
import 'package:programmit_app/l10n/app_localizations.dart';
import 'package:programmit_app/services/api_service.dart';
import 'package:programmit_app/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

enum _HomePanelError {
  none,
  gpsDisabled,
  gpsPermissionDenied,
  gpsPositionFailed,
  searchFailed,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
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
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          panelError = _HomePanelError.gpsDisabled;
          panelErrorDetail = '';
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
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

      final position = await Geolocator.getCurrentPosition(
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
        if (!mounted) return;
        showAppSnackBar(context, l10n.snackNoGps, Colors.red);
        return;
      }
    }

    setState(() {
      isLoading = true;
      panelError = _HomePanelError.none;
      panelErrorDetail = '';
    });

    try {
      final fetchedEvents = await ApiService.fetchNearbyEvents(
        lat: currentPosition!.latitude,
        lng: currentPosition!.longitude,
      );
      if (!mounted) return;
      setState(() {
        events = fetchedEvents;
        isLoading = false;
      });
      if (!mounted) return;
      if (fetchedEvents.isEmpty) {
        showAppSnackBar(context, l10n.snackNoMatchesNearby, Colors.orange);
      } else {
        showAppSnackBar(
          context,
          l10n.snackFoundSchedules(fetchedEvents.length),
          Colors.green,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        panelError = _HomePanelError.searchFailed;
        panelErrorDetail = e.toString();
      });
      showAppSnackBar(context, l10n.snackSearchFailed(e.toString()), Colors.red);
    }
  }

  Future<void> _searchByCode() async {
    final l10n = AppLocalizations.of(context);
    final code = _codeController.text;
    if (!nonEmptyInput(code)) {
      showAppSnackBar(context, l10n.snackEnterCode, Colors.orange);
      return;
    }

    final trimmedCode = code.trim();

    setState(() {
      isLoading = true;
      panelError = _HomePanelError.none;
      panelErrorDetail = '';
    });

    try {
      final results = await ApiService.searchByCode(
        code: trimmedCode,
        lat: currentPosition?.latitude ?? 0.0,
        lng: currentPosition?.longitude ?? 0.0,
      );
      if (!mounted) return;
      setState(() {
        events = results;
        isLoading = false;
      });
      if (!mounted) return;
      if (results.isEmpty) {
        showAppSnackBar(
          context,
          l10n.snackNoMatchesForCode(_codeController.text),
          Colors.orange,
        );
      } else {
        showAppSnackBar(
          context,
          l10n.snackFoundSchedules(results.length),
          Colors.green,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        panelError = _HomePanelError.searchFailed;
        panelErrorDetail = e.toString();
      });
      showAppSnackBar(context, l10n.snackSearchFailed(e.toString()), Colors.red);
    }
  }

  Future<void> _onLanguageSelected(Set<String> selected) async {
    await saveAppLocale(Locale(selected.first));
  }

  static const _facebookGroup =
      'https://www.facebook.com/groups/1310841980973835';

  Future<void> _openFacebookGroup(AppLocalizations l10n) async {
    final url = Uri.parse(_facebookGroup);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.snackFacebookError),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, st) {
      appLog('Facebook launch failed: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.snackFacebookError),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _logoBanner(AppLocalizations l10n) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(22),
      ),
      child: ColoredBox(
        color: AppColors.scaffold,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bannerWidth = constraints.maxWidth;
            return Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 10),
              child: Image.asset(
                'assets/logo.png',
                width: bannerWidth,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) {
                  appLog('Logo asset failed: $error');
                  return SizedBox(
                    width: bannerWidth,
                    child: Container(
                      color: AppColors.scaffold,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.sports_soccer,
                                size: 50,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.sports_basketball,
                                size: 50,
                                color: Colors.orange,
                              ),
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
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue,
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
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _searchCard(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              Color(0xFFFF9A56),
              AppColors.primaryDeep,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          child: Column(
            children: [
              TextField(
                controller: _codeController,
                style: const TextStyle(
                  color: AppColors.scaffold,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: l10n.hintEnterCode,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => _searchByCode(),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _searchByCode,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.scaffold,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.searchByCode,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: isLoading ? null : _searchByLocation,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.scaffold,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.searchNearby,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openFacebookGroup(l10n),
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.facebook,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'f',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: ColoredBox(
        color: AppColors.scaffold,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
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
                            backgroundColor: AppColors.scaffold,
                            foregroundColor: Colors.white70,
                            selectedBackgroundColor: AppColors.primary,
                            selectedForegroundColor: AppColors.scaffold,
                            side:
                                const BorderSide(color: Color(0x44FFFFFF)),
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
              ),
              SliverToBoxAdapter(child: _logoBanner(l10n)),
              SliverToBoxAdapter(child: _searchCard(l10n)),
              if (isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: LoadingWidget(),
                    ),
                  ),
                )
              else if (panelError != _HomePanelError.none)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
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
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 48,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 72,
                            color: Colors.white38,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.emptySearchPrompt,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                              height: 1.35,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = events[index];
                        return event.isMatch
                            ? MatchCard(event: event)
                            : EventCard(event: event);
                      },
                      childCount: events.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
