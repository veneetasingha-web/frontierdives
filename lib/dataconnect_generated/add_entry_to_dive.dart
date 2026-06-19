part of 'generated.dart';

class AddEntryToDiveVariablesBuilder {
  String diveId;
  String title;
  String contentType;
  String contentBody;
  final Optional<int> _complexityRating = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  AddEntryToDiveVariablesBuilder complexityRating(int? t) {
   _complexityRating.value = t;
   return this;
  }

  AddEntryToDiveVariablesBuilder(this._dataConnect, {required  this.diveId,required  this.title,required  this.contentType,required  this.contentBody,});
  Deserializer<AddEntryToDiveData> dataDeserializer = (dynamic json)  => AddEntryToDiveData.fromJson(jsonDecode(json));
  Serializer<AddEntryToDiveVariables> varsSerializer = (AddEntryToDiveVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AddEntryToDiveData, AddEntryToDiveVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AddEntryToDiveData, AddEntryToDiveVariables> ref() {
    AddEntryToDiveVariables vars= AddEntryToDiveVariables(diveId: diveId,title: title,contentType: contentType,contentBody: contentBody,complexityRating: _complexityRating,);
    return _dataConnect.mutation("AddEntryToDive", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AddEntryToDiveEntryInsert {
  final String id;
  AddEntryToDiveEntryInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddEntryToDiveEntryInsert otherTyped = other as AddEntryToDiveEntryInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const AddEntryToDiveEntryInsert({
    required this.id,
  });
}

@immutable
class AddEntryToDiveData {
  final AddEntryToDiveEntryInsert entry_insert;
  AddEntryToDiveData.fromJson(dynamic json):
  
  entry_insert = AddEntryToDiveEntryInsert.fromJson(json['entry_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddEntryToDiveData otherTyped = other as AddEntryToDiveData;
    return entry_insert == otherTyped.entry_insert;
    
  }
  @override
  int get hashCode => entry_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['entry_insert'] = entry_insert.toJson();
    return json;
  }

  const AddEntryToDiveData({
    required this.entry_insert,
  });
}

@immutable
class AddEntryToDiveVariables {
  final String diveId;
  final String title;
  final String contentType;
  final String contentBody;
  late final Optional<int>complexityRating;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AddEntryToDiveVariables.fromJson(Map<String, dynamic> json):
  
  diveId = nativeFromJson<String>(json['diveId']),
  title = nativeFromJson<String>(json['title']),
  contentType = nativeFromJson<String>(json['contentType']),
  contentBody = nativeFromJson<String>(json['contentBody']) {
  
  
  
  
  
  
    complexityRating = Optional.optional(nativeFromJson, nativeToJson);
    complexityRating.value = json['complexityRating'] == null ? null : nativeFromJson<int>(json['complexityRating']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AddEntryToDiveVariables otherTyped = other as AddEntryToDiveVariables;
    return diveId == otherTyped.diveId && 
    title == otherTyped.title && 
    contentType == otherTyped.contentType && 
    contentBody == otherTyped.contentBody && 
    complexityRating == otherTyped.complexityRating;
    
  }
  @override
  int get hashCode => Object.hashAll([diveId.hashCode, title.hashCode, contentType.hashCode, contentBody.hashCode, complexityRating.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['diveId'] = nativeToJson<String>(diveId);
    json['title'] = nativeToJson<String>(title);
    json['contentType'] = nativeToJson<String>(contentType);
    json['contentBody'] = nativeToJson<String>(contentBody);
    if(complexityRating.state == OptionalState.set) {
      json['complexityRating'] = complexityRating.toJson();
    }
    return json;
  }

  const AddEntryToDiveVariables({
    required this.diveId,
    required this.title,
    required this.contentType,
    required this.contentBody,
    required this.complexityRating,
  });
}

