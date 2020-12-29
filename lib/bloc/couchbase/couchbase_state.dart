part of 'couchbase_bloc.dart';

abstract class CouchbaseState extends Equatable {
  const CouchbaseState();
}

class CouchbaseInitial extends CouchbaseState {
  @override
  List<Object> get props => [];
}
