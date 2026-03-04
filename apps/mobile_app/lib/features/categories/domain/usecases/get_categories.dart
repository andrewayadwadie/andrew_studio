import 'package:injectable/injectable.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

@injectable
class GetCategories {
  final CategoryRepository _repository;
  const GetCategories(this._repository);

  Future<List<Category>> call(String appSlug) => _repository.getCategories(appSlug);
}
