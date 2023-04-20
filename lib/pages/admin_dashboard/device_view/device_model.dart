// To parse this JSON data, do
//
//     final deviceModule = deviceModuleFromJson(jsonString);

import 'dart:convert';

DeviceModule deviceModuleFromJson(String str) =>
    DeviceModule.fromJson(json.decode(str));

String deviceModuleToJson(DeviceModule data) => json.encode(data.toJson());

class DeviceModule {
  DeviceModule({
    required this.deviceInfo,
  });

  List<DeviceInfo> deviceInfo;

  factory DeviceModule.fromJson(Map<String, dynamic> json) => DeviceModule(
        deviceInfo: List<DeviceInfo>.from(
            json["device_info"].map((x) => DeviceInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "device_info": List<dynamic>.from(deviceInfo.map((x) => x.toJson())),
      };
}

class DeviceInfo {
  DeviceInfo({
    required this.deviceSerial,
    required this.deviceName,
    required this.deviceStatus,
    required this.id,
  });

  String deviceSerial;
  String deviceName;
  bool deviceStatus;
  String id;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
        deviceSerial: json["device_serial"],
        deviceName: json["device_name"],
        deviceStatus: json["device_status"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "device_serial": deviceSerial,
        "device_name": deviceName,
        "device_status": deviceStatus,
        "id": id,
      };
}
