import 'package:injectable/injectable.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remote;
  const CategoryRepositoryImpl(this._remote);

  @override
  Future<List<Category>> getCategories(String appSlug) => _remote.getCategories(appSlug);
}
