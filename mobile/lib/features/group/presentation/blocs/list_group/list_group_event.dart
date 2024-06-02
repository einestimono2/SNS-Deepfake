part of 'list_group_bloc.dart';

sealed class ListGroupEvent extends Equatable {
  const ListGroupEvent();

  @override
  List<Object?> get props => [];
}

class GetMyGroups extends ListGroupEvent {
  final int? page;
  final int? size;
  
  const GetMyGroups({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}
