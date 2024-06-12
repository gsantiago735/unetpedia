part of 'general_cubit.dart';

class GeneralState extends Equatable {
  const GeneralState({
    this.errorText = "",
    this.degrees,
    this.degreesStatus = WidgetStatus.initial,
    this.logOutStatus = WidgetStatus.initial,
    this.categoryStatus = WidgetStatus.initial,
    this.categoriesResponseModel,
  });

  // General
  final String errorText;

  // Degrees
  final WidgetStatus degreesStatus;
  final DegreesResponseModel? degrees;

  // Log Out
  final WidgetStatus logOutStatus;

  // Categories (Departaments)
  final WidgetStatus categoryStatus;
  final CategoriesResponseModel? categoriesResponseModel;

  @override
  List<Object?> get props => [
        errorText,
        degrees,
        degreesStatus,
        logOutStatus,
        categoryStatus,
        categoriesResponseModel,
      ];

  GeneralState copyWith({
    String? errorText,
    Wrapped<DegreesResponseModel?>? degrees,
    WidgetStatus? degreesStatus,
    WidgetStatus? logOutStatus,
    WidgetStatus? categoryStatus,
    Wrapped<CategoriesResponseModel?>? categoriesResponseModel,
  }) {
    return GeneralState(
        errorText: errorText ?? this.errorText,
        degrees: degrees != null ? degrees.value : this.degrees,
        degreesStatus: degreesStatus ?? this.degreesStatus,
        logOutStatus: logOutStatus ?? this.logOutStatus,
        categoryStatus: categoryStatus ?? this.categoryStatus,
        categoriesResponseModel: categoriesResponseModel != null
            ? categoriesResponseModel.value
            : this.categoriesResponseModel);
  }
}
