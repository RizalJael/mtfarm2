// FILEPATH: /d:/flutter_pro/mtfarm2/mtfarm2/lib/widgets/recent_activity_item.dart

import 'package:flutter/material.dart';
import '../../models/recent_activity_model.dart';
// import '../models/recent_activity_model.dart';

class RecentActivityItem extends StatelessWidget {
  final RecentActivity activity;

  const RecentActivityItem({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: _getIconForType(activity.type),
        title: Text(activity.description),
        subtitle: Text(_getFormattedDate(activity.timestamp)),
        trailing: Icon(Icons.chevron_right),
        onTap: () => _navigateToDetail(context),
      ),
    );
  }

  Widget _getIconForType(ActivityType type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case ActivityType.populasi:
        iconData = Icons.pets;
        iconColor = Colors.blue;
        break;
      case ActivityType.mortal:
        iconData = Icons.warning;
        iconColor = Colors.red;
        break;
      case ActivityType.potong:
        iconData = Icons.cut;
        iconColor = Colors.green;
        break;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor),
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  void _navigateToDetail(BuildContext context) {
    // Implementasi navigasi ke halaman detail berdasarkan tipe aktivitas
    switch (activity.type) {
      case ActivityType.populasi:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => PopulasiDetailPage(id: activity.id)));
        break;
      case ActivityType.mortal:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MortalDetailPage(id: activity.id)));
        break;
      case ActivityType.potong:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => PotongDetailPage(id: activity.id)));
        break;
    }
  }
}
