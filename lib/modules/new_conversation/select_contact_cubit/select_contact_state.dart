import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:equatable/equatable.dart';

abstract class SelectUserState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends SelectUserState {}

class LoadSuccessState extends SelectUserState {
  final List<ApiContact> data;
  final List<ApiContact> selectedData;

  LoadSuccessState(
    this.data, [
    this.selectedData = const [],
  ]);

  @override
  List<Object> get props => [data, selectedData];
}

class SelectionChangedState extends LoadSuccessState {
  final ApiContact selected;

  SelectionChangedState({
    required List<ApiContact> data,
    List<ApiContact> selectedData = const [],
    required this.selected,
  }) : super(data, selectedData);

  @override
  List<Object> get props => [selected, data, selectedData];
}

class LoadFailureState extends SelectUserState {
  final String errorMessage;

  LoadFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FilterEmptyState extends LoadSuccessState {
  final String keyword;

  FilterEmptyState({
    required this.keyword,
    required List<ApiContact> data,
    List<ApiContact> selectedData = const [],
  }) : super(data, selectedData);

  @override
  List<Object> get props => [keyword, data, selectedData];
}
