import 'package:clothes_randomizer_app/constants/result_status.dart';

class Result<DataType> {
  final DataType? data;
  final ResultStatus status;
  final String? message;

  Result({
    this.data,
    required this.status,
    this.message,
  });
}
