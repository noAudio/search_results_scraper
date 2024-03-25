import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:fluent_ui/fluent_ui.dart' as fl;
import 'package:search_results/actions/index.dart';
import 'package:search_results/enums/site_enum.dart';
import 'package:search_results/logic/csv_generator.dart';
import 'package:search_results/logic/scraper.dart';
import 'package:search_results/models/app_state.dart';
import 'package:search_results/reducers/app_reducer.dart';

void main() {
  final store = Store<AppState>(appReducer, initialState: AppState.initial());
  fl.runApp(
    StoreProvider<AppState>(
      store: store,
      child: const MainApp(),
    ),
  );
}

class MainApp extends fl.StatelessWidget {
  const MainApp({super.key});

  @override
  fl.Widget build(fl.BuildContext context) {
    return fl.FluentApp(
      debugShowCheckedModeBanner: false,
      theme: fl.FluentThemeData(
        accentColor: fl.Colors.blue,
        brightness: fl.Brightness.dark,
      ),
      home: const Home(),
    );
  }
}

class Home extends fl.StatelessWidget {
  const Home({super.key});

  @override
  fl.Widget build(fl.BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) => store,
      builder: (context, store) {
        AppState state = store.state;

        return fl.Center(
          child: fl.Column(
            children: [
              fl.Row(
                children: [
                  fl.Padding(
                    padding: const fl.EdgeInsets.all(8.0),
                    child: fl.SizedBox(
                      width: 250,
                      child: fl.TextBox(
                        autofocus: true,
                        placeholder: 'Enter search term',
                        enabled: !state.isSearching,
                        onChanged: (value) {
                          store
                              .dispatch(SetSearchTermAction(searchTerm: value));
                        },
                      ),
                    ),
                  ),
                  fl.Button(
                    onPressed: state.isSearching
                        ? null
                        : () async {
                            store.dispatch(
                                SetErrorMessageAction(errorMessage: ''));
                            if (state.searchTerm == '') {
                              store.dispatch(SetErrorMessageAction(
                                  errorMessage:
                                      'Please type in a keyword to search.'));
                            } else {
                              store.dispatch(
                                  SetSearchStateAction(isSearching: true));
                              for (var site in SiteEnum.values) {
                                var scraper = Scraper(
                                    searchTerm: state.searchTerm,
                                    site: site,
                                    store: store);
                                try {
                                  await scraper.getData();
                                } catch (e) {
                                  store.dispatch(SetErrorMessageAction(
                                      errorMessage: e.toString()));
                                }

                                String fileName = DateFormat.yMd()
                                    .add_jm()
                                    .format(DateTime.now());
                                store.dispatch(SetInfoMessageAction(
                                    infoMessage: 'Generating csv file...'));
                                var csvGenerator = CSVGenerator(
                                  fileName: fileName,
                                  results: scraper.searchResults,
                                  site: site,
                                );
                                await csvGenerator.generate();

                                store.dispatch(SetInfoMessageAction(
                                    infoMessage:
                                        'File(s) saved to Documents/Google Search Results/'));
                              }
                            }
                            store.dispatch(
                                SetSearchStateAction(isSearching: false));
                            store.dispatch(
                                SetInfoMessageAction(infoMessage: ''));
                          },
                    child: fl.Text(
                      state.isSearching ? 'Searching...' : 'Search',
                    ),
                  ),
                ],
              ),
              const fl.SizedBox(),
              state.infoMessage == ''
                  ? const fl.SizedBox()
                  : fl.Padding(
                      padding: const fl.EdgeInsets.all(8.0),
                      child: fl.Row(
                        children: [
                          const fl.SizedBox(
                            width: 25,
                            height: 25,
                            child: fl.ProgressRing(),
                          ),
                          fl.Padding(
                            padding: const fl.EdgeInsets.only(left: 5.0),
                            child: fl.Text(state.infoMessage),
                          ),
                        ],
                      ),
                    ),
              state.errorMessage == ''
                  ? const fl.SizedBox()
                  : fl.Padding(
                      padding: const fl.EdgeInsets.all(8.0),
                      child: fl.Text(
                        state.errorMessage,
                        style: fl.TextStyle(color: fl.Colors.red),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
