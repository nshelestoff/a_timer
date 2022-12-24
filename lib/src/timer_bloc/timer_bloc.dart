import 'dart:async';

import 'package:an_exercise_timer/src/slider_bloc/slider_cubit.dart';
import 'package:an_exercise_timer/src/timer_page.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:an_exercise_timer/src/timer.dart';

part 'timer_event.dart';

part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker, required SliderCubit sliderCubit})
      : _ticker = ticker, _sliderCubit = sliderCubit,
        super(TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<_TimerTicked>(_onTicked);

    _sliderCubit.stream.listen((event) {
      _duration = _sliderCubit.state.value.round();
    });

  }

  final SliderCubit _sliderCubit;
  final Ticker _ticker;
  static int _duration = 60;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = event.incrementing
        ? _ticker
            .incrementingTick()
            .listen((duration) => add(_TimerTicked(duration: duration)))
        : _ticker
            .decrementingTick(ticks: _duration)
            .listen((duration) => add(_TimerTicked(duration: duration)));
  }


  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(_duration));
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration)
          : const TimerRunComplete(),
    );
  }
}
