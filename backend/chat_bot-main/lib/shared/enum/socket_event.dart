// ignore_for_file: constant_identifier_names

enum SocketEvent {
  UPDATE_NODE('update_node'), // Trigger node state
  NODE_CHANGED('node_updated'), // Node state changed
  MODULE_STATE('module_updated'), // Module on/off
  MODULE_ADDED('module_added'), // New module added
  TIMER_CHANGED('timer_updated'), // MCU listen timer changed
  SENSOR_UPDATED('sensor_updated'), // Sensor value updated
  MODULE_CONTROL('module_control'); // Send command to module

  final String value;
  const SocketEvent(this.value);
}

enum ControlCommand {
  restart,
  reset,
  updateWiFi,
}
