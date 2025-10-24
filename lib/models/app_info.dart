import 'package:flutter/foundation.dart';

class AppInfo {
  final String appName;
  final String packageName;
  final Uint8List? icon;
  bool isLocked;

  AppInfo({
    required this.appName,
    required this.packageName,
    this.icon,
    this.isLocked = false,
  });

  AppInfo copyWith({
    String? appName,
    String? packageName,
    Uint8List? icon,
    bool? isLocked,
  }) {
    return AppInfo(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      icon: icon ?? this.icon,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'isLocked': isLocked,
    };
  }

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appName: json['appName'] as String,
      packageName: json['packageName'] as String,
      isLocked: json['isLocked'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppInfo && other.packageName == packageName;
  }

  @override
  int get hashCode => packageName.hashCode;
}
