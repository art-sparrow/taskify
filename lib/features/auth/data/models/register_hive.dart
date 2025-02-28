import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'register_hive.g.dart';

@HiveType(typeId: 0)
class SignUpEntity extends Equatable {
  const SignUpEntity({
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
}
