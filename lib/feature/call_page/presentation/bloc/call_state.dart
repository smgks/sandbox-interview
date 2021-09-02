part of 'call_bloc.dart';

@immutable
abstract class CallState {}

class CallInitial extends CallState {}

class CallPrepared extends CallState {}

class CallEnded extends CallState {}
