part of 'mentorship_cubit.dart';

class MentorshipState extends Equatable {
  const MentorshipState({
    this.exception,
    this.genericStatus = WidgetStatus.initial,
    this.departmentSelected,
    this.subjectSelected,
    this.mentorships,
  });

  // Generic
  final WidgetStatus genericStatus;
  final DataException? exception;

  final List<MentorshipModel>? mentorships;

  // Add mentorship
  final DepartmentModel? departmentSelected;
  final SubjectModel? subjectSelected;

  @override
  List<Object?> get props => [
    exception,
    genericStatus,
    departmentSelected,
    subjectSelected,
    mentorships,
  ];

  MentorshipState copyWith({
    DataException? exception,
    WidgetStatus? genericStatus,
    Wrapped<DepartmentModel?>? departmentSelected,
    Wrapped<SubjectModel?>? subjectSelected,
    Wrapped<List<MentorshipModel>?>? mentorships,
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
      mentorships: mentorships != null ? mentorships.value : this.mentorships,
    );
  }
}
