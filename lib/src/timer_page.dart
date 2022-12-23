import 'package:an_exercise_timer/src/checkbox_bloc/checkbox_cubit.dart';
import 'package:an_exercise_timer/src/slider_bloc/slider_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:an_exercise_timer/src/timer.dart';
import 'package:an_exercise_timer/src/actions.dart' as actions;
import 'actions.dart';
import 'background.dart';
import 'timer_bloc/timer_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);
  static bool incrementingTimer = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TimerBloc(ticker: Ticker()),
        ),
        BlocProvider(
          create: (_) => CheckboxCubit(),
        ),
        BlocProvider(
          create: (_) => SliderCubit(),
        )
      ],
      child: TimerView(),
    );
  }
}

class TimerView extends StatefulWidget {
  TimerView({Key? key}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: AppBar(
        title: const Text('Flutter Timer'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (_scaffoldKey.currentState!.isDrawerOpen) {
              Navigator.pop(context);
            } else {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
      ),
      body: Scaffold(
        key: _scaffoldKey,
        drawer: const Drawer(),
        body: Stack(
          children: [
            const Background(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.0),
                  child: Center(child: TimerText()),
                ),
                const actions.Actions(),
                BlocBuilder<CheckboxCubit, CheckboxState>(
                  builder: (context, state) {
                    return Checkbox(
                      value: state.isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          context.read<CheckboxCubit>().changeValue(value!);
                        });
                      },
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
      '$duration',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
