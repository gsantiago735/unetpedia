part of 'general_cubit.dart';

class GeneralState extends Equatable {
  const GeneralState({
    this.errorText = "",
    this.degrees,
    this.degreesStatus = WidgetStatus.initial,
    this.getUserStatus = WidgetStatus.initial,
    this.userResponseModel,
    this.logOutStatus = WidgetStatus.initial,
    this.categoryStatus = WidgetStatus.initial,
    this.categoriesResponseModel,
    this.subjectsStatus = WidgetStatus.initial,
    this.subjectsResponseModel,
    this.categorySelected,
    this.moreSubjectsStatus = WidgetStatus.initial,
    this.subjectSelected,
    this.categoryQuery = "",
    this.subjectQuery = "",
  });

  // General
  final String errorText;

  // Degrees
  final WidgetStatus degreesStatus;
  final DegreesResponseModel? degrees;

  // Authentication
  final WidgetStatus getUserStatus;
  final RegisterResponseModel? userResponseModel;
  final WidgetStatus logOutStatus;

  // Categories (Departaments)
  final String categoryQuery;
  final WidgetStatus categoryStatus;
  final CategoryResponseModel? categorySelected;
  final CategoriesResponseModel? categoriesResponseModel;

  // Subjects
  final String subjectQuery;
  final WidgetStatus subjectsStatus;
  final WidgetStatus moreSubjectsStatus;
  final SubjectResponseModel? subjectSelected;
  final SubjectsResponseModel? subjectsResponseModel;

  @override
  List<Object?> get props => [
        errorText,
        degrees,
        degreesStatus,
        getUserStatus,
        userResponseModel,
        logOutStatus,
        categoryStatus,
        categoriesResponseModel,
        subjectsStatus,
        subjectsResponseModel,
        categorySelected,
        moreSubjectsStatus,
        subjectSelected,
        categoryQuery,
        subjectQuery,
      ];

  GeneralState copyWith({
    String? errorText,
    Wrapped<DegreesResponseModel?>? degrees,
    WidgetStatus? degreesStatus,
    WidgetStatus? getUserStatus,
    Wrapped<RegisterResponseModel?>? userResponseModel,
    WidgetStatus? logOutStatus,
    WidgetStatus? categoryStatus,
    Wrapped<CategoriesResponseModel?>? categoriesResponseModel,
    WidgetStatus? subjectsStatus,
    Wrapped<SubjectsResponseModel?>? subjectsResponseModel,
    Wrapped<CategoryResponseModel?>? categorySelected,
    WidgetStatus? moreSubjectsStatus,
    Wrapped<SubjectResponseModel?>? subjectSelected,
    String? categoryQuery,
    String? subjectQuery,
  }) {
    return GeneralState(
      errorText: errorText ?? this.errorText,
      degrees: degrees != null ? degrees.value : this.degrees,
      degreesStatus: degreesStatus ?? this.degreesStatus,
      getUserStatus: getUserStatus ?? this.getUserStatus,
      userResponseModel: userResponseModel != null
          ? userResponseModel.value
          : this.userResponseModel,
      logOutStatus: logOutStatus ?? this.logOutStatus,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      categoriesResponseModel: categoriesResponseModel != null
          ? categoriesResponseModel.value
          : this.categoriesResponseModel,
      subjectsStatus: subjectsStatus ?? this.subjectsStatus,
      subjectsResponseModel: subjectsResponseModel != null
          ? subjectsResponseModel.value
          : this.subjectsResponseModel,
      categorySelected: categorySelected != null
          ? categorySelected.value
          : this.categorySelected,
      moreSubjectsStatus: moreSubjectsStatus ?? this.moreSubjectsStatus,
      subjectSelected: subjectSelected != null
          ? subjectSelected.value
          : this.subjectSelected,
      categoryQuery: categoryQuery ?? this.categoryQuery,
      subjectQuery: subjectQuery ?? this.subjectQuery,
    );
  }
}
