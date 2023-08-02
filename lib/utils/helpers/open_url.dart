import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

openUrl(String url) async {
  var uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    launchUrl(uri);
  } else {
    AppDialogs.toast('Không thể mở link');
  }
}
