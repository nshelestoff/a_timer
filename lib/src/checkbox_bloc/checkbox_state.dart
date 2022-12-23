part of 'checkbox_cubit.dart';


class CheckboxState {
  bool isChecked;

  CheckboxState({required this.isChecked}) {
    if (isChecked) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }

  CheckboxState copyWith({required bool changeState}) {
    return CheckboxState(isChecked: changeState);
  }
}