part of 'search_history_bloc.dart';

sealed class SearchHistoryState extends Equatable {
  const SearchHistoryState();

  @override
  List<Object?> get props => [];
}

final class SHInitialState extends SearchHistoryState {}

final class SHInProgressState extends SearchHistoryState {}

class SHSuccessfulState extends SearchHistoryState {
  final List<SearchModel> userHistories;
  final List<SearchModel> postHistories;

  final int? timestamp;

  const SHSuccessfulState({
    required this.userHistories,
    required this.postHistories,
    this.timestamp,
  });

  @override
  List<Object?> get props => [postHistories, userHistories, timestamp];

  SHSuccessfulState copyWith({
    List<SearchModel>? userHistories,
    List<SearchModel>? postHistories,
    int? timestamp,
  }) {
    return SHSuccessfulState(
      userHistories: userHistories ?? this.userHistories,
      postHistories: postHistories ?? this.postHistories,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class SHFailureState extends SearchHistoryState {
  final String message;

  const SHFailureState(this.message);

  @override
  List<Object> get props => [message];
}
