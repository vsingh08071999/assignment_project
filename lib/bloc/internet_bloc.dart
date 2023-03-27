import 'dart:async';

import 'package:assignment_project/bloc/internet_event.dart';
import 'package:assignment_project/bloc/internet_state.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  InternetBloc() : super(InternetLoadingState()) {
    on<InternetEvent>((event, emit) => emit(InternetLostState()));
    on<InternetConnectedEvent>((event, emit) => emit(InternetConnectedState()));

    _connectivity.onConnectivityChanged.listen((eventListen) {
      print("bloc data ${eventListen}");
      if (eventListen == ConnectivityResult.mobile ||
          eventListen == ConnectivityResult.wifi) {
        add(InternetConnectedEvent());
      } else {
        add(InternetLostEvent());
      }
    });
  }
}
