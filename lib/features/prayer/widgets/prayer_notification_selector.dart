import 'package:flutter/material.dart';
import '../../core/services/settings_service.dart';

/// Reusable widget for selecting prayer notification type
/// Shows different UI based on [compact] parameter
class PrayerNotificationTypeSelector extends StatefulWidget {
  final String prayerName;
  final String prayerDisplayName;
  final bool compact;
  final VoidCallback? onChanged;

  const PrayerNotificationTypeSelector({
    Key? key,
    required this.prayerName,
    required this.prayerDisplayName,
    this.compact = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<PrayerNotificationTypeSelector> createState() => _PrayerNotificationTypeSelectorState();
}

class _PrayerNotificationTypeSelectorState extends State<PrayerNotificationTypeSelector> {
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = AppSettings.instance.getPrayerNotificationType(widget.prayerName);
  }

  void _updateNotificationType(String type) {
    setState(() => _selectedType = type);
    AppSettings.instance.setPrayerNotificationType(widget.prayerName, type);
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      // Compact version: SegmentedButton for Prayer Times Screen
      return SegmentedButton<String>(
        segments: const [
          ButtonSegment(
            value: 'adhan',
            label: Tooltip(
              message: 'Adhan',
              child: Icon(Icons.music_note, size: 18),
            ),
          ),
          ButtonSegment(
            value: 'alarm',
            label: Tooltip(
              message: 'Alarm',
              child: Icon(Icons.alarm, size: 18),
            ),
          ),
          ButtonSegment(
            value: 'notification',
            label: Tooltip(
              message: 'Notification',
              child: Icon(Icons.notifications, size: 18),
            ),
          ),
        ],
        selected: {_selectedType},
        onSelectionChanged: (selected) {
          _updateNotificationType(selected.first);
        },
      );
    } else {
      // Full version: Radio buttons for Settings Screen
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.prayerDisplayName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('🔔 Adhan (الأذان)'),
                  value: 'adhan',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    if (value != null) {
                      _updateNotificationType(value);
                    }
                  },
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('⏰ Alarm (تنبيه)'),
                  value: 'alarm',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    if (value != null) {
                      _updateNotificationType(value);
                    }
                  },
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('📢 Notification (إشعار)'),
                  value: 'notification',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    if (value != null) {
                      _updateNotificationType(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    }
  }
}
