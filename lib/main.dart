import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:fluent_ui/fluent_ui.dart' as fl;
import 'package:search_results/actions/index.dart';
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

        return fl.Column(
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
                        store.dispatch(SetSearchTermAction(searchTerm: value));
                      },
                    ),
                  ),
                ),
                fl.Button(
                  onPressed: state.isSearching
                      ? null
                      : () {
                          if (state.searchTerm == '') {}
                          store.dispatch(
                              SetSearchStateAction(isSearching: true));
                          print(state.searchTerm);
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
                        fl.Text(state.infoMessage),
                      ],
                    ),
                  ),
          ],
        );
      },
    );
  }
}
