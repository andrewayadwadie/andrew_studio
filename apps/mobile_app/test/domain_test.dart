import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper.dart';
import 'package:mobile_app/features/wallpapers/domain/repositories/wallpaper_repository.dart';
import 'package:mobile_app/features/wallpapers/domain/usecases/get_wallpapers.dart';
import 'package:mobile_app/features/categories/domain/entities/category.dart';
import 'package:mobile_app/features/categories/domain/repositories/category_repository.dart';
import 'package:mobile_app/features/categories/domain/usecases/get_categories.dart';

class MockWallpaperRepository extends Mock implements WallpaperRepository {}
class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  group('Wallpaper entity', () {
    test('equality based on id', () {
      const w1 = Wallpaper(id: '1', imageUrl: 'https://example.com/1.jpg');
      const w2 = Wallpaper(id: '1', imageUrl: 'https://example.com/1.jpg');
      const w3 = Wallpaper(id: '2', imageUrl: 'https://example.com/1.jpg');
      expect(w1, equals(w2));
      expect(w1, isNot(equals(w3)));
    });

    test('default values are applied', () {
      const w = Wallpaper(id: '1', imageUrl: 'https://example.com/1.jpg');
      expect(w.source, equals('upload'));
      expect(w.tags, isEmpty);
      expect(w.downloadCount, equals(0));
    });
  });

  group('Category entity', () {
    test('equality based on id and name', () {
      const c1 = Category(id: '1', name: 'Nature');
      const c2 = Category(id: '1', name: 'Nature');
      const c3 = Category(id: '2', name: 'Nature');
      expect(c1, equals(c2));
      expect(c1, isNot(equals(c3)));
    });
  });

  group('GetWallpapers use case', () {
    late MockWallpaperRepository repo;
    late GetWallpapers usecase;

    setUp(() {
      repo = MockWallpaperRepository();
      usecase = GetWallpapers(repo);
    });

    test('delegates to repository', () async {
      const wallpapers = [
        Wallpaper(id: '1', imageUrl: 'https://example.com/1.jpg'),
        Wallpaper(id: '2', imageUrl: 'https://example.com/2.jpg'),
      ];
      when(() => repo.getWallpapers(
        appSlug: any(named: 'appSlug'),
        categoryId: any(named: 'categoryId'),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      )).thenAnswer((_) async => wallpapers);

      final result = await usecase(appSlug: 'walluxe');
      expect(result, equals(wallpapers));
    });
  });

  group('GetCategories use case', () {
    late MockCategoryRepository repo;
    late GetCategories usecase;

    setUp(() {
      repo = MockCategoryRepository();
      usecase = GetCategories(repo);
    });

    test('delegates to repository', () async {
      const categories = [
        Category(id: '1', name: 'Nature'),
        Category(id: '2', name: 'Abstract'),
      ];
      when(() => repo.getCategories(any())).thenAnswer((_) async => categories);

      final result = await usecase('walluxe');
      expect(result, equals(categories));
    });
  });
}
