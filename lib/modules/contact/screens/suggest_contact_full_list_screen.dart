import 'package:chat_365/common/blocs/suggest_contact_cubit/cubit/suggest_contact_cubit.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/modules/contact/widget/suggest_contact_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestContactFullListScreen extends StatelessWidget {
  const SuggestContactFullListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SuggestContactCubit suggestContactCubit =
        context.read<SuggestContactCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gợi ý kết bạn'),
        elevation: 2,
      ),
      body: BlocProvider<SuggestContactCubit>.value(
        value: suggestContactCubit,
        child: BlocBuilder<SuggestContactCubit, SuggestContactState>(
          bloc: suggestContactCubit,
          builder: (context, state) {
            if (state is SuggestContactSuccess)
              return ListView.builder(
                itemCount: state.contacts.length,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (context, index) {
                  final ApiContact contact = state.contacts[index];
                  return SuggestContactItem(
                    contact: contact,
                  );
                },
              );

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
