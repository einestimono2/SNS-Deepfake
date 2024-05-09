import 'package:flutter/material.dart';

class FriendSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => query.isEmpty ? close(context, null) : query = '',
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => const BackButton();

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
