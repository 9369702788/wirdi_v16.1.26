import 'package:flutter/material.dart';
import '../../../core/services/settings_service.dart';

class PrayerNotificationTypeSelector extends StatefulWidget {
  final String prayerName;
  final String prayerDisplayName;
  final AppSettings appSettings;
  final bool compact;

  const PrayerNotificationTypeSelector({
    super.key,
    required this.prayerName,
    required this.prayerDisplayName,
    required this.appSettings,
    this.compact = false,
  });

  @override
  State<PrayerNotificationTypeSelector> createState() => _PrayerNotificationTypeSelectorState();
}

class _PrayerNotificationTypeSelectorState extends State<PrayerNotificationTypeSelector> {
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.appSettings.getPrayerNotificationType(widget.prayerName);
  }

  void _updateNotificationType(String type) async {
    setState(() => _selectedType = type);
    await widget.appSettings.setPrayerNotificationType(widget.prayerName, type);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'adhan', label: Icon(Icons.music_note, size: 18)),
          ButtonSegment(value: 'alarm', label: Icon(Icons.alarm, size: 18)),
          ButtonSegment(value: 'notification', label: Icon(Icons.notifications, size: 18)),
        ],
        selected: {_selectedType},
        onSelectionChanged: (selected) => _updateNotificationType(selected.first),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.prayerDisplayName, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('🔔 Adhan'),
                  value: 'adhan',
                  groupValue: _selectedType,
                  onChanged: (value) => value != null ? _updateNotificationType(value) : null,
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('⏰ Alarm'),
                  value: 'alarm',
                  groupValue: _selectedType,
                  onChanged: (value) => value != null ? _updateNotificationType(value) : null,
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('📢 Notification'),
                  value: 'notification',
                  groupValue: _selectedType,
                  onChanged: (value) => value != null ? _updateNotificationType(value) : null,
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
