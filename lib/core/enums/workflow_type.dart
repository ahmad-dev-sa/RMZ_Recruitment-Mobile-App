enum WorkflowType {
  recruitment,
  rental,
  dailyHourly,
  unknown;

  /// Parses a string from the backend into a [WorkflowType]
  static WorkflowType fromString(String? type) {
    if (type == null) return WorkflowType.unknown;
    
    switch (type.toLowerCase()) {
      case 'recruitment':
        return WorkflowType.recruitment;
      case 'rental':
        return WorkflowType.rental;
      case 'daily_hourly':
      case 'dailyhourly':
      case 'daily':
      case 'hourly':
        return WorkflowType.dailyHourly;
      default:
        return WorkflowType.unknown;
    }
  }

  /// Converts [WorkflowType] to a string suitable for backend
  String toJson() {
    switch (this) {
      case WorkflowType.recruitment:
        return 'recruitment';
      case WorkflowType.rental:
        return 'rental';
      case WorkflowType.dailyHourly:
        return 'daily_hourly';
      case WorkflowType.unknown:
        return 'unknown';
    }
  }
}
