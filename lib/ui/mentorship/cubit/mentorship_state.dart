part of 'mentorship_cubit.dart';

class MentorshipState extends Equatable {
  const MentorshipState({
    this.exception,
    this.genericStatus = WidgetStatus.initial,
    this.departmentSelected,
    this.subjectSelected,
  });

  // Generic
  final WidgetStatus genericStatus;
  final DataException? exception;

  // Add mentorship
  final DepartmentModel? departmentSelected;
  final SubjectModel? subjectSelected;

  @override
  List<Object?> get props => [
    exception,
    genericStatus,
    departmentSelected,
    subjectSelected,
  ];

  MentorshipState copyWith({
    DataException? exception,
    WidgetStatus? genericStatus,
    Wrapped<DepartmentModel?>? departmentSelected,
    Wrapped<SubjectModel?>? subjectSelected,
  }) {
    return MentorshipState(
      exception: exception ?? this.exception,
      genericStatus: genericStatus ?? this.genericStatus,
      departmentSelected: departmentSelected != null
          ? departmentSelected.value
          : this.departmentSelected,
      subjectSelected: subjectSelected != null
          ? subjectSelected.value
          : this.subjectSelected,
    );
  }
}
