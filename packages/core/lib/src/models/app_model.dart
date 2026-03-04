import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_model.freezed.dart';
part 'app_model.g.dart';

@freezed
class AppModel with _$AppModel {
  const factory AppModel({
    required String id,
    required String name,
    required String slug,
    String? iconUrl,
    String? description,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _AppModel;

  factory AppModel.fromJson(Map<String, dynamic> json) =>
      _$AppModelFromJson(json);
}
