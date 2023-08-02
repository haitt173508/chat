part of 'suggest_contact_cubit.dart';

abstract class SuggestContactState {
  const SuggestContactState();
}

class SuggestContactSuccess extends SuggestContactState {
  final List<ApiContact> contacts;

  SuggestContactSuccess(List<ApiContact> contacts)
      : this.contacts = [...contacts];
}

class SuggestContactStateError extends SuggestContactState {
  final ExceptionError error;

  SuggestContactStateError(this.error);
}

class SuggestContactStateLoading extends SuggestContactState {}
