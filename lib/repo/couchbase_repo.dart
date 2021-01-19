

import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'package:flutter/services.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/MessageModel.dart';
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
    print("chaneeels $channels");
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

  Future<Document> createChat(UserModel receiver, UserModel owner, String message) async {
    await this.enableReplicas(
        dbChange: (dbChange){
          print("XXXXXXXXXXXXXXXXXXXXXXXXX ${dbChange.documentIDs}");

        },
      replicaChange: (event) {
          print("POPOPOPOPOPOPOPOPOPOPOPOPOPOPO $event");

      }
    );
    ChatModel chatModel = ChatModel(
      receiver: receiver,
      owner: owner,
      messages: [MessageModel(
        owner: owner,
        receiver: receiver,
        id: ObjectId().toHexString(),
        message: message,
        state: "new"
      )],
      lastUpdate: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    Document doc = chatModel.toDocument();
    try {
      await database.saveDocument(doc);
    } on PlatformException{
      print("Exception dasjdhgaskjdhaskhdjkshakjd sahdk jhaashkdsa");
      return null;
    }
    this.dispose();
    return doc;
  }

  Future<List<Document>> getChangesDocs(changes) async {
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
    if (database == null) {
      await this.enableReplicas(
          dbChange: (dbChange) {
            print("KUAKUAKAUAKAUAKUAKAUAKAAKAAKAUA ${dbChange.documentIDs}");
          },
          replicaChange: (event) {
            print("OSAKODKSAODKSAODKOSAKDSOAKDOKSAODKSAOKDOSAKDOKASs $event");
          }
      );
    }
    Document doc = await database.document(docId);
    return doc;
  }


  void sendMessage(ChatModel chatModel, UserModel sender, UserModel receiver, String message) async {
    Document doc = await this.getDocument(chatModel.id);
    List<dynamic> chat = doc.getList("chat");
    chat.add(
        MessageModel(
          state: "new",
          message: message,
          id: ObjectId().toHexString(),
          owner: sender,
          receiver: receiver,
          sent: DateTime.now().millisecondsSinceEpoch.toString(),
        ).toMap()
    );
    doc = (await this.database.document(doc.id))
        ?.toMutable()
        ?.setList("chat", chat);
    if (doc != null) {
      await database.saveDocument(doc);
    }
  }


  void dispose() async{
    print("cuando se hace dispose");
    await replicator?.removeChangeListener(_listenerToken);
    await replicator?.stop();
    await replicator?.dispose();
    await database?.removeChangeListener(_dbListenerToken);
    await database?.close();
  }
}