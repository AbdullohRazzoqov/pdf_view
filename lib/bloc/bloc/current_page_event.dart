part of 'current_page_bloc.dart';

class CurrentPageEvent extends Equatable {
  int currentPage;
  CurrentPageEvent({required this.currentPage});

  @override
  List<Object> get props => [currentPage];
}
