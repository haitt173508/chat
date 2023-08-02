part of 'typing_detector_bloc.dart';

class TypingDetectorState {
  TypingDetectorState(Set<int> displayingText)
      : _typingUserIds = {...displayingText};

  final Set<int> _typingUserIds;

  Set<int> get typingUserIds => _typingUserIds;

  add(int value) => TypingDetectorState(_typingUserIds..add(value));

  remove(int value) => TypingDetectorState(_typingUserIds..remove(value));

  // @override
  // List<Object> get props => [..._displayingText, DateTime.now()];
}
