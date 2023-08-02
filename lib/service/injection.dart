import 'package:chat_365/data/datas/typing_user.dart';
import 'package:chat_365/service/app_service.dart';
import 'package:chat_365/service/firebase_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  //
  getIt.registerSingleton<AppService>(AppService());
  //
  getIt.registerSingleton<FirebaseService>(FirebaseService());
  //
  getIt.registerSingleton<TypingUser>(const TypingUser());
}
