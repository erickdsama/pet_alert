

import 'package:couchbase_lite/couchbase_lite.dart';

class CouchBaseRepo {
  Database database;
  Replicator replicator;
  ListenerToken _dbListenerToken;

  Future enableReplicas() async {
    // Create replicators to push and pull changes to and from the cloud.
    database = await Database.initWithName("pet_alert");

    ReplicatorConfiguration config =
    ReplicatorConfiguration(database, "ws://192.168.3.6:4985/pet_alert/");
    config.replicatorType = ReplicatorType.pushAndPull;
    config.continuous = true;

    config.authenticator = BasicAuthenticator("petApp", "passApp");
    var replicator = Replicator(config);
    print(" >>> WHATPPPP??? $replicator");
    // Listen to replicator change events.
    ListenerToken _listenerToken = replicator.addChangeListener((ReplicatorChange event) {
      if (event.status.error != null) {
        print(">>>> Error: " + event.status.error);
      }
      print(" >>> data: ${event.status.activity.toString()}");
    });


    _dbListenerToken = database.addChangeListener((dbChange) {
      for (var change in dbChange.documentIDs) {
        print("change in id: $change");
      }
    });
    replicator.start();

  }
  Future<Document> getDocument(docId) async {
    Document doc = await database.document(docId);
    return doc;

  }
}