part of 'search_post_bloc.dart';

sealed class SearchPostEvent extends Equatable {
  const SearchPostEvent();

  @override
  List<Object?> get props => [];
}

class SearchPostSubmit extends SearchPostEvent {
  final String keyword;
  final int? page;
  final int? size;
  final bool saveHistory;

  const SearchPostSubmit({
    required this.keyword,
    this.page,
    this.size,
    this.saveHistory = true,
  });

  @override
  List<Object?> get props => [page, size, keyword, saveHistory];
}
