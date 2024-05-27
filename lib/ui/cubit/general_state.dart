part of 'general_cubit.dart';

class GeneralState extends Equatable {
  const GeneralState({
    this.idUser,
  });

  final int? idUser;

  @override
  List<Object?> get props => [
        idUser,
      ];

  GeneralState copyWith({
    Wrapped<int?>? idUser,
  }) {
    return GeneralState(
      idUser: idUser != null ? idUser.value : this.idUser,
    );
  }
}
