import 'dart:convert';

class SearchResult {
  final String searchTerm;
  final DateTime dateTime;
  final bool isSponsored;
  final String website;
  final String destinationURL;
  final String headlineText;
  final String subText;
  SearchResult({
    required this.searchTerm,
    required this.dateTime,
    required this.isSponsored,
    required this.website,
    required this.destinationURL,
    required this.headlineText,
    required this.subText,
  });

  SearchResult copyWith({
    String? searchTerm,
    DateTime? dateTime,
    bool? isSponsored,
    String? website,
    String? destinationURL,
    String? headlineText,
    String? subText,
  }) {
    return SearchResult(
      searchTerm: searchTerm ?? this.searchTerm,
      dateTime: dateTime ?? this.dateTime,
      isSponsored: isSponsored ?? this.isSponsored,
      website: website ?? this.website,
      destinationURL: destinationURL ?? this.destinationURL,
      headlineText: headlineText ?? this.headlineText,
      subText: subText ?? this.subText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'searchTerm': searchTerm,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'isSponsored': isSponsored,
      'website': website,
      'destinationURL': destinationURL,
      'headlineText': headlineText,
      'subText': subText,
    };
  }

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      searchTerm: map['searchTerm'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      isSponsored: map['isSponsored'] ?? false,
      website: map['website'] ?? '',
      destinationURL: map['destinationURL'] ?? '',
      headlineText: map['headlineText'] ?? '',
      subText: map['subText'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchResult.fromJson(String source) =>
      SearchResult.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SearchResult(searchTerm: $searchTerm, dateTime: $dateTime, isSponsored: $isSponsored, website: $website, destinationURL: $destinationURL, headlineText: $headlineText, subText: $subText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchResult &&
        other.searchTerm == searchTerm &&
        other.dateTime == dateTime &&
        other.isSponsored == isSponsored &&
        other.website == website &&
        other.destinationURL == destinationURL &&
        other.headlineText == headlineText &&
        other.subText == subText;
  }

  @override
  int get hashCode {
    return searchTerm.hashCode ^
        dateTime.hashCode ^
        isSponsored.hashCode ^
        website.hashCode ^
        destinationURL.hashCode ^
        headlineText.hashCode ^
        subText.hashCode;
  }
}
