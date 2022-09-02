import 'package:bloc/bloc.dart';

class MainNavigationCubit extends Cubit<int> {
  MainNavigationCubit() : super(0);

  void setCurrentTabIndex(int newTabIndex) => emit(newTabIndex);
}
