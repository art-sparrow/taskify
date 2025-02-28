import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'register_hive.g.dart';

@HiveType(typeId: 0)
class RegistrationEntity extends Equatable {
  const RegistrationEntity({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.joinedOn = '',
    this.uid = '',
    this.fcmToken = '',
  });
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phone;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String joinedOn;

  @HiveField(4)
  final String uid;

  @HiveField(5)
  final String fcmToken;

  @override
  List<Object?> get props => [name, phone, email, joinedOn, uid, fcmToken];

  RegistrationEntity copyWith({
    String? name,
    String? phone,
    String? email,
    String? joinedOn,
    String? uid,
    String? fcmToken,
  }) {
    return RegistrationEntity(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      joinedOn: joinedOn ?? this.joinedOn,
      uid: uid ?? this.uid,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
