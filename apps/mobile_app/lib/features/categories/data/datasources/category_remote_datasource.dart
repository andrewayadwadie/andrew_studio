import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories(String appSlug);
}

@Injectable(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient _client;
  const CategoryRemoteDataSourceImpl(this._client);

  @override
  Future<List<CategoryModel>> getCategories(String appSlug) async {
    final response = await _client.get('/apps/$appSlug/categories');
    final data = (response['data'] as List<dynamic>);
    return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
