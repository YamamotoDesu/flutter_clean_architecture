

import 'package:flutter_clean_architecture/fetures/daily_news/domain/entities/article.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';

import '../../../../core/resources/data_state.dart';
import '../repository/article_repository.dart';

class GetArticleUseCase implements UseCase<DataState<List<ArticleEntity>>, void> {
  final ArticleRepository _repository;

  GetArticleUseCase(this._repository);

  @override
  Future<DataState<List<ArticleEntity>>> call({void params}) {
    return  _repository.getNewsArticles();
  }
}