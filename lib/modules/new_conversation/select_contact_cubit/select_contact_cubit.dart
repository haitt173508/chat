// import 'package:chat_365/core/error_handling/app_error_state.dart';
// import 'package:chat_365/main.dart';
// import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
// import 'package:chat_365/modules/contact/model/contact.dart';
// import 'package:chat_365/modules/contact/repos/contact_list_repo.dart';
// import 'package:chat_365/utils/data/extensions/context_extension.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'select_contact_state.dart';

// enum ContactSelectionMode { single, many }

// class SelectContactCubit extends Cubit<SelectUserState> {
//   SelectContactCubit(this.selectionMode, this._contactListRepo)
//       : super(LoadingState()) {
//     searchKey.addListener(_searchKeyListener);
//     _getContacts();
//   }

//   final ContactSelectionMode selectionMode;
//   late final ValueNotifier<String> searchKey = ValueNotifier('');

//   late final List<Contact> _contacts;
//   late final List<Contact> _selectedContacts = [];
//   late final List<Contact> _filteredContacts = [];
//   List<Contact> get selectedContacts => _selectedContacts;

//   final ContactListRepo _contactListRepo;

//   selectContact(Contact contact) {
//     _selectedContacts.add(contact);

//     _emitSelectionChanged(contact);
//   }

//   removeSelection(int index) =>
//       _emitSelectionChanged(_selectedContacts.removeAt(index));

//   _emitSelectionChanged(Contact contact) => emit(SelectionChangedState(
//         data: List.from(_contacts)
//           ..removeWhere((e) => _selectedContacts.contains(e)),
//         selectedData: _selectedContacts,
//         selected: contact,
//       ));

//   _getContacts() async {
//     try {
//       List<Contact> allContactsInCompany =
//           await _contactListRepo.getAllContactsInCompany(
//         (navigatorKey.currentContext!.userInfo() as UserInfo).companyId!,
//       );
//       List<Contact> myContacts = await _contactListRepo.getMyContact();

//       allContactsInCompany
//         ..removeWhere((e) => myContacts.contains(e))
//         ..insertAll(0, myContacts);

//       _contacts = allContactsInCompany;

//       emit(LoadSuccessState(_contacts));
//     } catch (e) {
//       emit(LoadFailureState(
//         AppErrorStateExt.getFriendlyErrorString(e),
//       ));
//     }
//   }

//   _searchKeyListener() {
//     final List<String> keys = searchKey.value.trim().toLowerCase().split(' ')
//       ..removeWhere((e) => e.isEmpty);

//     if (keys.isEmpty) _emitFilterEmptyResult();

//     final effectiveSearchKey = RegExp(
//       "(${keys.join('|')})",
//       caseSensitive: false,
//       unicode: true,
//     );

//     _filteredContacts
//       ..clear()
//       ..addAll(
//         _contacts.where(
//           (e) => e.searchKey.contains(effectiveSearchKey),
//         ),
//       );

//     if (_filteredContacts.length == 0)
//       _emitFilterEmptyResult();
//     else
//       emit(FilterEmptyState(
//         keyword: searchKey.value,
//         data: _filteredContacts,
//         selectedData: _selectedContacts,
//       ));
//   }

//   _emitFilterEmptyResult() => emit(FilterEmptyState(
//         keyword: searchKey.value,
//         data: _contacts,
//         selectedData: _selectedContacts,
//       ));

//   @override
//   Future<void> close() {
//     searchKey.removeListener(_searchKeyListener);
//     return super.close();
//   }
// }
