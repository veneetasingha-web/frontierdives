part of 'generated.dart';

class GetUserLibraryVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetUserLibraryVariablesBuilder(this._dataConnect, );
  Deserializer<GetUserLibraryData> dataDeserializer = (dynamic json)  => GetUserLibraryData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetUserLibraryData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetUserLibraryData, void> ref() {
    
    return _dataConnect.query("GetUserLibrary", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetUserLibraryLibraries {
  final GetUserLibraryLibrariesUser user;
  GetUserLibraryLibraries.fromJson(dynamic json):
  
  user = GetUserLibraryLibrariesUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserLibraryLibraries otherTyped = other as GetUserLibraryLibraries;
    return user == otherTyped.user;
    
  }
  @override
  int get hashCode => user.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['user'] = user.toJson();
    return json;
  }

  const GetUserLibraryLibraries({
    required this.user,
  });
}

@immutable
class GetUserLibraryLibrariesUser {
  final String username;
  final String? bio;
  final List<GetUserLibraryLibrariesUserDivesOnAuthor> dives_on_author;
  GetUserLibraryLibrariesUser.fromJson(dynamic json):
  
  username = nativeFromJson<String>(json['username']),
  bio = json['bio'] == null ? null : nativeFromJson<String>(json['bio']),
  dives_on_author = (json['dives_on_author'] as List<dynamic>)
        .map((e) => GetUserLibraryLibrariesUserDivesOnAuthor.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserLibraryLibrariesUser otherTyped = other as GetUserLibraryLibrariesUser;
    return username == otherTyped.username && 
    bio == otherTyped.bio && 
    dives_on_author == otherTyped.dives_on_author;
    
  }
  @override
  int get hashCode => Object.hashAll([username.hashCode, bio.hashCode, dives_on_author.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['username'] = nativeToJson<String>(username);
    if (bio != null) {
      json['bio'] = nativeToJson<String?>(bio);
    }
    json['dives_on_author'] = dives_on_author.map((e) => e.toJson()).toList();
    return json;
  }

  const GetUserLibraryLibrariesUser({
    required this.username,
    this.bio,
    required this.dives_on_author,
  });
}

@immutable
class GetUserLibraryLibrariesUserDivesOnAuthor {
  final String title;
  final List<GetUserLibraryLibrariesUserDivesOnAuthorEntriesOnDive> entries_on_dive;
  GetUserLibraryLibrariesUserDivesOnAuthor.fromJson(dynamic json):
  
  title = nativeFromJson<String>(json['title']),
  entries_on_dive = (json['entries_on_dive'] as List<dynamic>)
        .map((e) => GetUserLibraryLibrariesUserDivesOnAuthorEntriesOnDive.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserLibraryLibrariesUserDivesOnAuthor otherTyped = other as GetUserLibraryLibrariesUserDivesOnAuthor;
    return title == otherTyped.title && 
    entries_on_dive == otherTyped.entries_on_dive;
    
  }
  @override
  int get hashCode => Object.hashAll([title.hashCode, entries_on_dive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    json['entries_on_dive'] = entries_on_dive.map((e) => e.toJson()).toList();
    return json;
  }

  const GetUserLibraryLibrariesUserDivesOnAuthor({
    required this.title,
    required this.entries_on_dive,
  });
}

@immutable
class GetUserLibraryLibrariesUserDivesOnAuthorEntriesOnDive {
  final String title;
  final int? complexityRating;
  GetUserLibraryLibrariesUserDivesOnAuthorEntriesOnDive.fromJson(dynamic json):
  
  title = nativeFromJson<String>(json['title']),
  complexityRating = json['complexityRating'] == null ? null : nativeFromJson<int>(json['complexityRating']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserLibraryLibrariesUserDivesOnAuthorEntriesOnDive otherTyped = other as GetUserLibraryLibrariesUserDivesOnAuthorEntriesOnDive;
    return title == otherTyped.title && 
    complexityRating == otherTyped.complexityRating;
    
  }
  @override
  int get hashCode => Object.hashAll([title.hashCode, complexityRating.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    if (complexityRating != null) {
      json['complexityRating'] = nativeToJson<int?>(complexityRating);
    }
    return json;
  }

  const GetUserLibraryLibrariesUserDivesOnAuthorEntriesOnDive({
    required this.title,
    this.complexityRating,
  });
}

@immutable
class GetUserLibraryData {
  final List<GetUserLibraryLibraries> libraries;
  GetUserLibraryData.fromJson(dynamic json):
  
  libraries = (json['libraries'] as List<dynamic>)
        .map((e) => GetUserLibraryLibraries.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetUserLibraryData otherTyped = other as GetUserLibraryData;
    return libraries == otherTyped.libraries;
    
  }
  @override
  int get hashCode => libraries.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['libraries'] = libraries.map((e) => e.toJson()).toList();
    return json;
  }

  const GetUserLibraryData({
    required this.libraries,
  });
}

