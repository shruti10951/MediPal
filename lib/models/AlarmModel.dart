class AlarmModel{
  final String alarmId;
  final String message;
  final String userId;
  final String time;
  final String status;
  final String medicationId;

  AlarmModel(this.alarmId, this.message, this.userId, this.time, this.status,
      this.medicationId);

  Map<String, dynamic> toMap(){
    return {
      'alarmId' : alarmId,
      'message' : message,
      'userId' : userId,
      'time' : time,
      'status' : status,
      'medicationId' : medicationId,
    };
  }
}