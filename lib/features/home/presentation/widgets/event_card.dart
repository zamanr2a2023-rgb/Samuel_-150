import 'package:flutter/material.dart';
import 'package:programmit_app/core/constants/app_colors.dart';
import 'package:programmit_app/features/events/data/models/event.dart';
import 'package:programmit_app/features/events/presentation/screens/match_detail_screen.dart';
import 'package:programmit_app/l10n/app_localizations.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  void _openDetail(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MatchDetailScreen(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const radius = 20.0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      elevation: 0,
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: InkWell(
        onTap: () => _openDetail(context),
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      l10n.labelEvent,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Event logo and name
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      event.fullImageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.event,
                            color: Colors.white54,
                            size: 38,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 13,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${event.dag}  kl. ${event.tid}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Address
              Row(
                children: [
                  Icon(Icons.location_on, size: 15, color: Colors.red[400]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Distance
              if (event.distance > 0) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.navigation, size: 13, color: Colors.blue[300]),
                    const SizedBox(width: 4),
                    Text(
                      event.formattedDistance,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 6),

              // Tap hint
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.touch_app, size: 13, color: Colors.white30),
                  const SizedBox(width: 4),
                  Text(
                    l10n.tapForDetails,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.white30),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
