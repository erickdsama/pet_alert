import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'couchbase_event.dart';
part 'couchbase_state.dart';

class CouchbaseBloc extends Bloc<CouchbaseEvent, CouchbaseState> {

  @override
  Stream<CouchbaseState> mapEventToState(
    CouchbaseEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  @override
  CouchbaseState get initialState => CouchbaseInitial();
}
