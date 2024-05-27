import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/generic/generic.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit() : super(const GeneralState());

  //final _userProvider = UserProvider();

  void setUserId(int? idUser) =>
      emit(state.copyWith(idUser: Wrapped.value(idUser)));
}
