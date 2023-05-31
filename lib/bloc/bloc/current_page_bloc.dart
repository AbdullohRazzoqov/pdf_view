import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_page_event.dart';
part 'current_page_state.dart';

class CurrentPageBloc extends Bloc<CurrentPageEvent, CurrentPageState> {
  CurrentPageBloc() : super(CurrentPageState(selectPage: 0)) {
    on<CurrentPageEvent>((event, emit) {
      print(state);
      emit(
        CurrentPageState(selectPage: event.currentPage),
      );
    });
  }
}
