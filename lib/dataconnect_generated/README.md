# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetUserLibrary
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getUserLibrary().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserLibraryData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getUserLibrary();
GetUserLibraryData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getUserLibrary().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateUser
#### Required Arguments
```dart
String username = ...;
String email = ...;
ExampleConnector.instance.createUser(
  username: username,
  email: email,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateUser, we created `CreateUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateUserVariablesBuilder {
  ...
   CreateUserVariablesBuilder bio(String? t) {
   _bio.value = t;
   return this;
  }
  CreateUserVariablesBuilder expertiseLevel(String? t) {
   _expertiseLevel.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createUser(
  username: username,
  email: email,
)
.bio(bio)
.expertiseLevel(expertiseLevel)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateUserData, CreateUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createUser(
  username: username,
  email: email,
);
CreateUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String username = ...;
String email = ...;

final ref = ExampleConnector.instance.createUser(
  username: username,
  email: email,
).ref();
ref.execute();
```


### CreateDive
#### Required Arguments
```dart
String title = ...;
String description = ...;
String category = ...;
ExampleConnector.instance.createDive(
  title: title,
  description: description,
  category: category,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateDive, we created `CreateDiveBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateDiveVariablesBuilder {
  ...
   CreateDiveVariablesBuilder tags(List<String>? t) {
   _tags.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createDive(
  title: title,
  description: description,
  category: category,
)
.tags(tags)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateDiveData, CreateDiveVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createDive(
  title: title,
  description: description,
  category: category,
);
CreateDiveData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String title = ...;
String description = ...;
String category = ...;

final ref = ExampleConnector.instance.createDive(
  title: title,
  description: description,
  category: category,
).ref();
ref.execute();
```


### AddEntryToDive
#### Required Arguments
```dart
String diveId = ...;
String title = ...;
String contentType = ...;
String contentBody = ...;
ExampleConnector.instance.addEntryToDive(
  diveId: diveId,
  title: title,
  contentType: contentType,
  contentBody: contentBody,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AddEntryToDive, we created `AddEntryToDiveBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AddEntryToDiveVariablesBuilder {
  ...
   AddEntryToDiveVariablesBuilder complexityRating(int? t) {
   _complexityRating.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.addEntryToDive(
  diveId: diveId,
  title: title,
  contentType: contentType,
  contentBody: contentBody,
)
.complexityRating(complexityRating)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AddEntryToDiveData, AddEntryToDiveVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.addEntryToDive(
  diveId: diveId,
  title: title,
  contentType: contentType,
  contentBody: contentBody,
);
AddEntryToDiveData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String diveId = ...;
String title = ...;
String contentType = ...;
String contentBody = ...;

final ref = ExampleConnector.instance.addEntryToDive(
  diveId: diveId,
  title: title,
  contentType: contentType,
  contentBody: contentBody,
).ref();
ref.execute();
```

