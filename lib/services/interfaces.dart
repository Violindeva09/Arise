abstract class CameraValidationService {
  Future<bool> validateAction(String actionId);
}

abstract class LocationValidationService {
  Future<bool> validateLocation(double lat, double lng, double radius);
}

abstract class BluetoothSensorService {
  Future<double> readSensorValue(String sensorId);
}

abstract class AIConfidenceEngine {
  Future<double> calculateConfidence(dynamic inputData);
}
