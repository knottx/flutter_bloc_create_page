import 'package:equatable/equatable.dart';

class HomeScreenState extends Equatable {
  final String name;
  final String stateCode;
  final String cubitCode;
  final String screenCode;

  const HomeScreenState({
    this.name = '',
    this.stateCode = '',
    this.cubitCode = '',
    this.screenCode = '',
  });

  @override
  List<Object?> get props => [
        name,
        stateCode,
        cubitCode,
        screenCode,
      ];

  HomeScreenState copyWith({
    String? name,
    String? stateCode,
    String? cubitCode,
    String? screenCode,
  }) {
    return HomeScreenState(
      name: name ?? this.name,
      stateCode: stateCode ?? this.stateCode,
      cubitCode: cubitCode ?? this.cubitCode,
      screenCode: screenCode ?? this.screenCode,
    );
  }
}
