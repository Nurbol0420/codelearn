import 'package:bloc/bloc.dart';
import 'package:codelearn/bloc/navigation/navigation_event.dart';
import 'package:codelearn/bloc/navigation/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(0)) {
    on<NavigateToTab>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}