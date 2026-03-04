import 'package:freezed_annotation/freezed_annotation.dart';

part 'pinterest_account_model.freezed.dart';
part 'pinterest_account_model.g.dart';

@freezed
class PinterestAccountModel with _$PinterestAccountModel {
  const factory PinterestAccountModel({
    required String id,
    required String username,
    required String accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _PinterestAccountModel;

  factory PinterestAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PinterestAccountModelFromJson(json);
}
