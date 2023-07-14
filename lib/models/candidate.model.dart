import 'package:clothes_randomizer_app/models/use.model.dart';

class CandidateModel {
  int? lowestCount;
  final List<UseModel> list = <UseModel>[];

  CandidateModel.empty();

  CandidateModel.withLowestCountAndUse({
    required this.lowestCount,
    required UseModel useModel,
  }) {
    list.add(
      useModel,
    );
  }

  CandidateModel withUse({
    required UseModel anotherUse,
  }) {
    final newCandidateModel = CandidateModel.empty();
    newCandidateModel.lowestCount = lowestCount;

    newCandidateModel.list.addAll(
      list,
    );

    newCandidateModel.list.add(
      anotherUse,
    );

    return newCandidateModel;
  }
}
