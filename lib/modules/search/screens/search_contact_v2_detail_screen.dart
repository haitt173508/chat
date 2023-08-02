import 'package:chat_365/common/widgets/dialogs/confirm_dialog.dart';
import 'package:chat_365/common/widgets/send_message_search_appbar.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/screens/chat_conversation_screen.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_cubit.dart';
import 'package:chat_365/modules/contact/cubits/contact_list_cubit/contact_list_state.dart';
import 'package:chat_365/modules/debouncer/text_editing_controller_debouncer.dart';
import 'package:chat_365/modules/search/screens/search_contact_v2_screen.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchContactV2DetailScreen extends StatefulWidget {
  const SearchContactV2DetailScreen({
    Key? key,
    this.initSearch = '',
    Widget Function(ConversationBasicInfo)? itemBuilder,
  })  : _itemBuilder = itemBuilder ?? kDefaultItemBuilder,
        super(key: key);

  final String initSearch;
  final Widget Function(ConversationBasicInfo) _itemBuilder;

  @override
  State<SearchContactV2DetailScreen> createState() =>
      _SearchContactV2DetailScreenState();
}

class _SearchContactV2DetailScreenState
    extends State<SearchContactV2DetailScreen> {
  final TextEditingController _controller = TextEditingController();
  late final TextEditingControllerDebouncer _debouncer;
  late final ContactListCubit _contactListCubit;
  final ValueNotifier<DialogState> _state = ValueNotifier(DialogState.init);

  @override
  void initState() {
    super.initState();
    _contactListCubit = context.read<ContactListCubit>();
    _controller.text = widget.initSearch;
    _debouncer = TextEditingControllerDebouncer(
      () => _contactListCubit.search(_controller.text),
      controller: _controller,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _debouncer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SendMessageSearchAppBar(
        controller: _controller,
        onSubmit: _contactListCubit.search,
        stateNotifier: _state,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallHeader(
            text: 'Gợi ý',
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          Expanded(
            child: BlocConsumer<ContactListCubit, ContactListState>(
              listener: (context, state) {
                if (state is LoadingState)
                  _state.value = DialogState.processing;
                else if (state is LoadSuccessState)
                  _state.value = DialogState.success;
                else if (state is LoadFailedState) {
                  _state.value = DialogState.init;
                  AppDialogs.toast(state.message);
                }
              },
              buildWhen: (_, current) => current is LoadSuccessState,
              builder: (_, state) {
                if (state is LoadSuccessState)
                  return ListView.builder(
                    itemCount: state.contactList.length,
                    itemBuilder: (context, index) {
                      var item = state.contactList[index];
                      return widget._itemBuilder(item);
                    },
                  );

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
