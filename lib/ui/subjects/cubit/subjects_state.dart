part of 'subjects_cubit.dart';

class SubjectsState extends Equatable {
  const SubjectsState({
    this.errorText = "",
  });

  // General
  final String errorText;

  @override
  List<Object?> get props => [
        errorText,
      ];

  SubjectsState copyWith({
    String? errorText,
  }) {
    return SubjectsState(
      errorText: errorText ?? this.errorText,
    );
  }
}
