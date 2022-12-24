import 'package:an_exercise_timer/src/checkbox_bloc/checkbox_cubit.dart';
import 'package:an_exercise_timer/src/slider_bloc/slider_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:an_exercise_timer/src/timer.dart';
import 'package:an_exercise_timer/src/actions.dart' as actions;
import 'actions.dart';
import 'background.dart';
import 'timer_bloc/timer_bloc.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);
  static bool incrementingTimer = true;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late SliderCubit _sliderCubit;
  late CheckboxCubit _checkboxCubit;

  @override
  void initState() {
    _sliderCubit = SliderCubit();
    _checkboxCubit = CheckboxCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              TimerBloc(ticker: const Ticker(), sliderCubit: _sliderCubit, checkboxCubit: _checkboxCubit),
        ),
        BlocProvider(
          create: (_) => _checkboxCubit,
        ),
        BlocProvider(
          create: (_) => _sliderCubit,
        )
      ],
      child: const TimerView(),
    );
  }
}

class TimerView extends StatefulWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: const Center(
            child: Text('Timer app'))),
        body: Stack(
          children: [
            const Background(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.0),
                  child: Center(child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      return TimerText();
                    },
                  )),
                ),
                const actions.Actions(),
                BlocBuilder<CheckboxCubit, CheckboxState>(
                  builder: (context, state) {
                    return Container(
                      width: 180,
                      child: CheckboxListTile(
                        value: state.isChecked,
                        title: Text('counting up', style: Theme.of(context).textTheme.subtitle1,),
                        onChanged: (bool? value) {
                          setState(() {
                            context.read<CheckboxCubit>().changeValue(value!);
                          });
                        },
                      ),
                    );
                  },
                ),
                Visibility(
                  visible: !(context.read<CheckboxCubit>().state.isChecked),
                  child: BlocBuilder<SliderCubit, SliderState>(
                    builder: (context, state) {
                      return Slider(
                        value: state.value,
                        max: 300,
                        divisions: 10,
                        label: state.value.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            context.read<SliderCubit>().changeValue(value);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
