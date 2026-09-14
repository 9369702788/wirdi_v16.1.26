import 'package:flutter/material.dart';
import '../../../core/services/settings_service.dart';

class PrayerNotificationTypeSelector extends StatefulWidget {
  final String prayerName;
  final String prayerDisplayName;
  final AppSettings appSettings;
  final bool compact;
  final VoidCallback? onChanged;

  const PrayerNotificationTypeSelector({
    super.key,
    required this.prayerName,
    required this.prayerDisplayName,
    required this.appSettings,
    this.compact = false,
    this.onChanged,
  });

  @override
  State<PrayerNotificationTypeSelector> createState() =>
      _PrayerNotificationTypeSelectorState();
}

class _PrayerNotificationTypeSelectorState
    extends State<PrayerNotificationTypeSelector> {
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.appSettings.getPrayerNotificationType(widget.prayerName);
  }

  Future<void> _updateNotificationType(String newType) async {
    setState(() {
      _selectedType = newType;
    });
    await widget.appSettings.setPrayerNotificationType(widget.prayerName, newType);
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      // Compact mode for Prayer Times screen
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${widget.prayerDisplayName} Notification:',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'adhan',
                  label: Text('🔔'),
                ),
                ButtonSegment<String>(
                  value: 'alarm',
                  label: Text('⏰'),
                ),
                ButtonSegment<String>(
                  value: 'notification',
                  label: Text('📢'),
                ),
              ],
              selected: <String>{_selectedType},
              onSelectionChanged: (Set<String> newSelection) {
                _updateNotificationType(newSelection.first);
              },
            ),
          ],
        ),
      );
    }

    // Full mode for Settings screen
    return RadioListTile<String>(
      title: Text(widget.prayerDisplayName),
      value: 'adhan',
      groupValue: _selectedType,
      onChanged: (value) => _updateNotificationType('adhan'),
    );
  }
}