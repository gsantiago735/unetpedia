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
  final WidgetStatus categoryStatus;
  final CategoriesResponseModel? categoriesResponseModel;

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
            : this.categoriesResponseModel);
  }
}
