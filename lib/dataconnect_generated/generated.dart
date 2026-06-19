library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'create_dive.dart';

part 'add_entry_to_dive.dart';

part 'get_user_library.dart';







class ExampleConnector {
  
  
  CreateUserVariablesBuilder createUser ({required String username, required String email, }) {
    return CreateUserVariablesBuilder(dataConnect, username: username,email: email,);
  }
  
  
  CreateDiveVariablesBuilder createDive ({required String title, required String description, required String category, }) {
    return CreateDiveVariablesBuilder(dataConnect, title: title,description: description,category: category,);
  }
  
  
  AddEntryToDiveVariablesBuilder addEntryToDive ({required String diveId, required String title, required String contentType, required String contentBody, }) {
    return AddEntryToDiveVariablesBuilder(dataConnect, diveId: diveId,title: title,contentType: contentType,contentBody: contentBody,);
  }
  
  
  GetUserLibraryVariablesBuilder getUserLibrary () {
    return GetUserLibraryVariablesBuilder(dataConnect, );
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-west1',
    'example',
    'frontierdives',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:0),
      storage: CacheStorage.persistent,
    );
    
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
