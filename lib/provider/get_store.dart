import 'package:attendence_management_system/provider/store_file/date_store.dart';
import 'package:attendence_management_system/provider/store_file/password_store.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<PasswordStore>(() => PasswordStore());
  getIt.registerLazySingleton<DateStore>(() => DateStore());
}
