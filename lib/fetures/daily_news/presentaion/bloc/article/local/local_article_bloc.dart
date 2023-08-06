import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/usercases/get_saved_article.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/bloc/article/local/local_article_event.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/bloc/article/local/local_article_state.dart';

import '../../../../domain/usercases/remove_article.dart';
import '../../../../domain/usercases/save _article.dart';

class LocalArticleBloc extends Bloc<LocalArticleEvent, LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SavedArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
  ) : super(const LocalArticlesLoading()) {
    on<GetSavedArticles>(onGetSavedArticles);
    on<SaveArticle>(onSavedArticle);
    on<RemoveArticle>(onRemoveArticle);
  }

  void onGetSavedArticles(GetSavedArticles getSavedArticles, Emitter<LocalArticlesState> emit) async {
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles: articles));
  }

  void onRemoveArticle(
      RemoveArticle removeArticle, Emitter<LocalArticlesState> emit) async {
    await _removeArticleUseCase(params: removeArticle.article!);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles: articles));
  }

  void onSavedArticle(
      SaveArticle saveArticle, Emitter<LocalArticlesState> emit) async {
    await _saveArticleUseCase();
       await _removeArticleUseCase(params: saveArticle.article!);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles: articles));
  }
}
