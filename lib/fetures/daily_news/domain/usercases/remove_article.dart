import 'package:flutter_clean_architecture/fetures/daily_news/domain/entities/article.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';

import '../repository/article_repository.dart';

class RemoveArticleUseCase implements UseCase<void, ArticleEntity> {
  final ArticleRepository _repository;

  RemoveArticleUseCase(this._repository);

  @override
  Future<void> call({ArticleEntity? params}) {
    return _repository.deleteArticle(params!);
  }
}
