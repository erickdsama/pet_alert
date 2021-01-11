

import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flutter/services.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/UserModel.dart';

class CouchBaseRepo {
  Database database;
  Replicator replicator;
  ListenerToken _dbListenerToken;
  ListenerToken _listenerToken;

  Future enableReplicas({
      channels,
      replicaChange, dbChange})
  async {
    database = await Database.initWithName(database_name);
    ReplicatorConfiguration config = ReplicatorConfiguration(database, URL_WS);
    config.replicatorType = ReplicatorType.pushAndPull;
    config.continuous = true;
    if (channels != null) {
      config.channels = channels;
    }
    // config.authenticator = BasicAuthenticator("petApp", "passApp");
    replicator = Replicator(config);
    // Listen to replicator change events.
    _listenerToken = replicator.addChangeListener(replicaChange);
    replicator.start();
    _dbListenerToken = database.addChangeListener(dbChange);
  }

  Future<ResultSet> fetchAllChats() async {
    var query = QueryBuilder.select([SelectResult.all(), SelectResult.expression(Meta.id)])
        .from(database_name).
    where(Expression.property("sender").notNullOrMissing().and(Expression.property("chat").notNullOrMissing()));
    try {
      return await query.execute();

    }on PlatformException {
      return null;
    }
  }

  Future<Document> createChat(UserModel receiver, UserModel owner) async {
    await this.enableReplicas(
        dbChange: (dbChange){
          print("dbCHangeeeee ${dbChange.documentIDs}");

        },
      replicaChange: (event) {
          print("changeeeeeeee $event");

      }
    );
    ChatModel chatModel = ChatModel(
      receiver: receiver,
      owner: owner,
      lastUpdate: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    Document doc = chatModel.toDocument();
    try {
      await database.saveDocument(doc);
    } on PlatformException{
      print("Exception dasjdhgaskjdhaskhdjkshakjd sahdk jhaashkdsa");
      return null;
    }
    return doc;
  }

  Future<List<Document>> getChangesDocs(changes) async {
    print("${changes}");
    List<Document> changesDocs = [];
    for (String change in changes) {
      Document doc = await this.getDocument(change);
      if(doc != null) {
        changesDocs.add(doc);
      }
    }

    return changesDocs;
  }

  Future<Document> getDocument(docId) async {
    return  await database.document(docId);
  }

  void dispose() async{
    await replicator?.removeChangeListener(_listenerToken);
    await replicator?.stop();
    await replicator?.dispose();
    await database?.removeChangeListener(_dbListenerToken);
    await database?.close();
  }
}