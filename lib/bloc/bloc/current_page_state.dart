part of 'current_page_bloc.dart';

 class CurrentPageState extends Equatable {
  int selectPage;
  CurrentPageState({required this.selectPage});

  @override
  List<Object> get props => [selectPage];
}
