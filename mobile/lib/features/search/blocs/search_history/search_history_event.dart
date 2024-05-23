part of 'search_history_bloc.dart';

sealed class SearchHistoryEvent extends Equatable {
  const SearchHistoryEvent();

  @override
  List<Object?> get props => [];
}

class GetSearchHistory extends SearchHistoryEvent {}

class AddSearchHistory extends SearchHistoryEvent {
  final String keyword;
  final SearchHistoryType type;

  const AddSearchHistory({
    required this.keyword,
    required this.type,
  });

  @override
  List<Object> get props => [keyword, type];
}

class DeleteSearchHistory extends SearchHistoryEvent {
  final String? keyword;
  final SearchHistoryType type;
  final bool all;

  const DeleteSearchHistory({
    required this.type,
    this.keyword,
    this.all = false,
  });

  @override
  List<Object?> get props => [keyword, type, all];
}
