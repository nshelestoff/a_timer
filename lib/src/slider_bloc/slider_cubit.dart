import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(const SliderState(value: 60));

  void changeValue(double value) {
    emit(state.copyWith(changeValue: value));
  }
}
