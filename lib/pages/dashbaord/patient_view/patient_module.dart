class Device {
  String deviceSerial;
  String deviceName;
  List<PatientData>? patientData;

  Device(
      {required this.deviceSerial,
      required this.deviceName,
      required this.patientData});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceSerial: json['device_serial'],
      deviceName: json['device_name'],
      patientData: json['patient_data'] != null
          ? (json['patient_data'] as List)
              .map((i) => PatientData.fromJson(i))
              .toList()
          : null,
    );
  }
}

class PatientData {
  String id;
  double height;
  String mobile;
  String name;
  String gender;
  String email;
  String dob;
  DateTime createdAt;
  String attachedDevice;
  String uid;
  DeviceInfo? deviceInfo;

  PatientData({
    required this.id,
    required this.height,
    required this.mobile,
    required this.name,
    required this.gender,
    required this.email,
    required this.dob,
    required this.createdAt,
    required this.attachedDevice,
    required this.uid,
    required this.deviceInfo,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id'],
      height: json['height'],
      mobile: json['mobile'],
      name: json['name'],
      gender: json['gender'],
      email: json['email'],
      dob: json['dob'],
      createdAt: DateTime.parse(json['created_at']),
      attachedDevice: json['attached_device'],
      uid: json['uid'],
      deviceInfo: json['device_info'] != null
          ? DeviceInfo.fromJson(json['device_info'])
          : null,
    );
  }
}

class DeviceInfo {
  bool deviceStatus;
  String deviceSerial;
  String deviceName;
  String attachedUid;

  DeviceInfo(
      {required this.deviceStatus,
      required this.deviceSerial,
      required this.deviceName,
      required this.attachedUid});

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceStatus: json['device_status'],
      deviceSerial: json['device_serial'],
      deviceName: json['device_name'],
      attachedUid: json['attached_uid'],
    );
  }
}
