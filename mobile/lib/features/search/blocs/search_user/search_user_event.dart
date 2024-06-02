part of 'search_user_bloc.dart';

sealed class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object?> get props => [];
}

class ResetState extends SearchUserEvent {}

class SearchUserSubmit extends SearchUserEvent {
  final String keyword;
  final int? page;
  final int? size;
  final bool saveHistory;

  const SearchUserSubmit({
    required this.keyword,
    this.page,
    this.size,
    this.saveHistory = true,
  });

  @override
  List<Object?> get props => [page, size, keyword, saveHistory];
}
