import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:flutter/material.dart';

class SheduleReminderScreen extends StatelessWidget {
  const SheduleReminderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm nhắc hẹn'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Column(
          children: [
            Image.asset(
              Images.img_clock,
              height: 50,
              width: 50,
            ),
            const SizedBox(height: 30),
            OutlineTextFormField(
              prefixIcon: Images.ic_edit2,
              decoration: InputDecoration(
                enabledBorder: AppBorderAndRadius.outlineInputBorder,
                border: AppBorderAndRadius.outlineInputBorder,
                focusedBorder: AppBorderAndRadius.outlineInputBorder,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 135,
              child: ElevatedButton(
                child: Text('Tạo'),
                onPressed: () {
                    Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
