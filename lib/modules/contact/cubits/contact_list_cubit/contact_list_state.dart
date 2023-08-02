import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/contact/model/filter_contacts_by.dart';
import 'package:equatable/equatable.dart';

abstract class ContactListState extends Equatable {
  final FilterContactsBy? filterContactsBy;

  const ContactListState(this.filterContactsBy);

  @override
  List<Object> get props => [if (filterContactsBy != null) filterContactsBy!];
}

class LoadingState extends ContactListState {
  LoadingState(FilterContactsBy? filterContactsBy) : super(filterContactsBy);
}

class LoadSuccessState extends ContactListState {
  final List<ConversationBasicInfo> contactList;
  final Map<FilterContactsBy, List<ConversationBasicInfo>> allContact;

  LoadSuccessState(
    FilterContactsBy? filterContactsBy, {
    this.contactList = const [],
    this.allContact = const {},
  }) : super(filterContactsBy);

  @override
  List<Object> get props => [DateTime.now()];
}

class LoadFailedState extends ContactListState {
  final String message;

  LoadFailedState(FilterContactsBy? filterContactsBy, this.message)
      : super(filterContactsBy);

  @override
  List<Object> get props => [message];
}
