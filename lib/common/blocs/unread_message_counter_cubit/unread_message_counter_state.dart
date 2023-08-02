part of 'unread_message_counter_cubit.dart';

class UnreadMessageCounterState extends Equatable {
  UnreadMessageCounterState(int counter)
      : this._counter = counter.clamp(0, double.infinity).toInt();

  final int _counter;

  int get counter => _counter;

  minus(int value) {
    var c = _counter - value;
    return UnreadMessageCounterState(c);
  }

  add(int value) {
    var c = _counter + value;
    return UnreadMessageCounterState(c);
  }

  readAll() => UnreadMessageCounterState(0);

  @override
  List<Object> get props => [_counter];
}
