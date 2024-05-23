part of 'search_user_bloc.dart';

sealed class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object?> get props => [];
}

class SearchUserSubmit extends SearchUserEvent {
  final String keyword;
  final int? page;
  final int? size;

  const SearchUserSubmit({
    required this.keyword,
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size, keyword];
}
