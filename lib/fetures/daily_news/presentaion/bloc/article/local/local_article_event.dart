

import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/entities/article.dart';

abstract class LocalArticleEvent extends Equatable {
  final ArticleEntity? article;

  const LocalArticleEvent({this.article});

  @override
  List<Object> get props => [];
}

class GetSavedArticles extends LocalArticleEvent {
  const GetSavedArticles();
}

class RemoveArticle extends LocalArticleEvent {
  const RemoveArticle({required ArticleEntity article}) : super(article: article);
}

class SaveArticle extends LocalArticleEvent {
  const SaveArticle({required ArticleEntity article}) : super(article: article);
}