part of 'generated.dart';

class CreateDiveVariablesBuilder {
  String title;
  String description;
  String category;
  final Optional<List<String>> _tags = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));

  final FirebaseDataConnect _dataConnect;  CreateDiveVariablesBuilder tags(List<String>? t) {
   _tags.value = t;
   return this;
  }

  CreateDiveVariablesBuilder(this._dataConnect, {required  this.title,required  this.description,required  this.category,});
  Deserializer<CreateDiveData> dataDeserializer = (dynamic json)  => CreateDiveData.fromJson(jsonDecode(json));
  Serializer<CreateDiveVariables> varsSerializer = (CreateDiveVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateDiveData, CreateDiveVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateDiveData, CreateDiveVariables> ref() {
    CreateDiveVariables vars= CreateDiveVariables(title: title,description: description,category: category,tags: _tags,);
    return _dataConnect.mutation("CreateDive", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateDiveDiveInsert {
  final String id;
  CreateDiveDiveInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateDiveDiveInsert otherTyped = other as CreateDiveDiveInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateDiveDiveInsert({
    required this.id,
  });
}

@immutable
class CreateDiveData {
  final CreateDiveDiveInsert dive_insert;
  CreateDiveData.fromJson(dynamic json):
  
  dive_insert = CreateDiveDiveInsert.fromJson(json['dive_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateDiveData otherTyped = other as CreateDiveData;
    return dive_insert == otherTyped.dive_insert;
    
  }
  @override
  int get hashCode => dive_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['dive_insert'] = dive_insert.toJson();
    return json;
  }

  const CreateDiveData({
    required this.dive_insert,
  });
}

@immutable
class CreateDiveVariables {
  final String title;
  final String description;
  final String category;
  late final Optional<List<String>>tags;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateDiveVariables.fromJson(Map<String, dynamic> json):
  
  title = nativeFromJson<String>(json['title']),
  description = nativeFromJson<String>(json['description']),
  category = nativeFromJson<String>(json['category']) {
  
  
  
  
  
    tags = Optional.optional(listDeserializer(nativeFromJson), listSerializer(nativeToJson));
    tags.value = json['tags'] == null ? null : (json['tags'] as List<dynamic>)
        .map((e) => nativeFromJson<String>(e))
        .toList();
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateDiveVariables otherTyped = other as CreateDiveVariables;
    return title == otherTyped.title && 
    description == otherTyped.description && 
    category == otherTyped.category && 
    tags == otherTyped.tags;
    
  }
  @override
  int get hashCode => Object.hashAll([title.hashCode, description.hashCode, category.hashCode, tags.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    json['description'] = nativeToJson<String>(description);
    json['category'] = nativeToJson<String>(category);
    if(tags.state == OptionalState.set) {
      json['tags'] = tags.toJson();
    }
    return json;
  }

  const CreateDiveVariables({
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
  });
}

