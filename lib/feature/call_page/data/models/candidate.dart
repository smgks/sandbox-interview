import 'package:flutter_sandbox/feature/call_page/domain/entities/candidate.dart';

class CandidateModel extends Candidate{
  CandidateModel({
    required String candidate,
    required String sdpMid,
    required int sdpMlineIndex,
  }) : super(candidate: candidate,sdpMid: sdpMid,sdpMlineIndex: sdpMlineIndex);

  Map<String,dynamic> toJson() => {
    'candidate':candidate,
    'sdpMid':sdpMid,
    'sdpMlineIndex':sdpMlineIndex,
  };

  factory CandidateModel.fromJson(Map<String,dynamic> data) => CandidateModel(
    candidate : data['candidate'] as String,
    sdpMid: data['sdpMid'] as String,
    sdpMlineIndex: data['sdpMlineIndex'] as int,
  );

  factory CandidateModel.fromDomain(Candidate parent) => CandidateModel(
      candidate: parent.candidate,
      sdpMid: parent.sdpMid,
      sdpMlineIndex: parent.sdpMlineIndex
  );
}