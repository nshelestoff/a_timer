part of 'slider_cubit.dart';

class SliderState extends Equatable {
  final double value;
  const SliderState({required this.value});

  @override
  List<Object> get props => [value];

  SliderState copyWith({required double changeValue}){
    return SliderState(value: changeValue);
  }
}


