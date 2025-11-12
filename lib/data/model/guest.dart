import 'package:equatable/equatable.dart';

enum GuestStatus { pending, present, absent }

class Guest extends Equatable {
  final String name;
  final GuestStatus status;

  const Guest({required this.name, this.status = GuestStatus.pending});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status.toString(),
    };
  }

  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      name: map['name'] ?? 'No Name',
      status: _statusFromString(map['status'] ?? 'GuestStatus.pending'),
    );
  }

  static GuestStatus _statusFromString(String statusStr) {
    if (statusStr == 'GuestStatus.present') return GuestStatus.present;
    if (statusStr == 'GuestStatus.absent') return GuestStatus.absent;
    // Backward compatibility for the boolean system
    if (statusStr == 'true') return GuestStatus.present;
    if (statusStr == 'false') return GuestStatus.absent; // Or pending, your choice
    return GuestStatus.pending;
  }

  Guest copyWith({String? name, GuestStatus? status}) {
    return Guest(
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [name, status];
}
