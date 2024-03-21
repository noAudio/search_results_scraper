import 'dart:convert';

import 'package:search_results/enums/site_enum.dart';

class AppState {
  final String searchTerm;
  final SiteEnum site;
  final String infoMessage;
  final bool isSearching;
  AppState({
    required this.searchTerm,
    required this.site,
    required this.infoMessage,
    required this.isSearching,
  });

  factory AppState.initial() => AppState(
        searchTerm: '',
        site: SiteEnum.baseWebsite,
        infoMessage: '',
        isSearching: false,
      );

  AppState copyWith({
    String? searchTerm,
    SiteEnum? site,
    String? infoMessage,
    bool? isSearching,
  }) {
    return AppState(
      searchTerm: searchTerm ?? this.searchTerm,
      site: site ?? this.site,
      infoMessage: infoMessage ?? this.infoMessage,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'searchTerm': searchTerm,
      'site': site,
      'infoMessage': infoMessage,
      'isSearching': isSearching,
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      searchTerm: map['searchTerm'] ?? '',
      site: map['site'] ?? SiteEnum.baseWebsite,
      infoMessage: map['infoMessage'] ?? '',
      isSearching: map['isSearching'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppState.fromJson(String source) =>
      AppState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppState(searchTerm: $searchTerm, site: $site, infoMessage: $infoMessage, isSearching: $isSearching)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppState &&
        other.searchTerm == searchTerm &&
        other.site == site &&
        other.infoMessage == infoMessage &&
        other.isSearching == isSearching;
  }

  @override
  int get hashCode {
    return searchTerm.hashCode ^
        site.hashCode ^
        infoMessage.hashCode ^
        isSearching.hashCode;
  }
}
