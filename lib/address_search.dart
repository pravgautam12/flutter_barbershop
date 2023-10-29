import 'package:flutter/material.dart';
import 'package:flutter_barbershop/place_service.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken, {required this.callBackFunc}) {
    apiClient = PlaceApiProvider(sessionToken);
  }

  final String sessionToken;
  late PlaceApiProvider
      apiClient; //making it late, will be initialized before it is called
  final Function() callBackFunc;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Suggestion('', '')); //check this
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); //returning an empty container, buildResults not used right now.
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : apiClient.fetchSuggestions(
              query, Localizations.localeOf(context).languageCode),
      builder: (context, snapshot) => query == ''
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(10)
              ),
              onPressed: () async {
                callBackFunc();
                close(context, Suggestion('', '')); //check this
              },
              child: const Row(
                //mainAxisSize: MainAxisSize.min, //when commented out, button covers the full length of the row
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blue
                  ),
                  Text(
                    "Use your location",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      )
                  )
                ],
              ),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title:
                        Text((snapshot.data?[index] as Suggestion).description),
                    onTap: () {
                      close(context, snapshot.data?[index] as Suggestion);
                    },
                  ),
                  itemCount: snapshot.data?.length,
                )
              : const Text('Loading...'),
    );
  }
}
