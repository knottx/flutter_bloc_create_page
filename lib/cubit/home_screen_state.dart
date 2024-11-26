import 'package:equatable/equatable.dart';

class HomeScreenState extends Equatable {
  final String name;

  const HomeScreenState({
    this.name = '',
  });

  @override
  List<Object?> get props => [
        name,
      ];

  HomeScreenState copyWith({
    String? name,
  }) {
    return HomeScreenState(
      name: name ?? this.name,
    );
  }
}
