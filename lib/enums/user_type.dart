enum UserType {
  passenger,
  driver,
}

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.passenger:
        return 'passenger';
      case UserType.driver:
        return 'driver';
    }
  }

  String get label {
    switch (this) {
      case UserType.passenger:
        return 'Pasajero';
      case UserType.driver:
        return 'Conductor';
    }
  }
}