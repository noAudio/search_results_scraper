import 'package:search_results/actions/index.dart';
import 'package:search_results/models/app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SetInfoMessageAction) {
    return state.copyWith(infoMessage: action.infoMessage);
  } else if (action is SetSearchStateAction) {
    return state.copyWith(isSearching: action.isSearching);
  } else if (action is SetSearchTermAction) {
    return state.copyWith(searchTerm: action.searchTerm);
  } else if (action is SetSiteAction) {
    return state.copyWith(site: action.site);
  }

  return state;
}
