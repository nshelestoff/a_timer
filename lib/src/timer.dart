

class Ticker {
  const Ticker();

  Stream<int> incrementingTick(){
    return Stream.periodic(const Duration(seconds: 1), (x) => x + 1);
  }

  Stream<int> decrementingTick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
