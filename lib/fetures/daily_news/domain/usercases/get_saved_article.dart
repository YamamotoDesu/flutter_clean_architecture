

import 'package:flutter_clean_architecture/fetures/daily_news/domain/entities/article.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';

import '../repository/article_repository.dart';

class GetSavedArticleUseCase implements UseCase<List<ArticleEntity>, void> {
  final ArticleRepository _repository;

  GetSavedArticleUseCase(this._repository);

  @override
  Future<List<ArticleEntity>> call({void params}) {
    return  _repository.getSavedArticles();
  }
}