
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/resources/data_state.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/domain/usercases/get_article.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/bloc/article/remote/remote_article_event.dart';
import 'package:flutter_clean_architecture/fetures/daily_news/presentaion/bloc/article/remote/remote_article_state.dart';


class RemoteArticlesBloc extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {

  final GetArticleUseCase _getArticleUseCase;

  RemoteArticlesBloc(this._getArticleUseCase) : super(const RemoteArticlesLoading()) {
    on <GetArticles> (onGetArticles);
  }

  void onGetArticles(GetArticles event, Emitter<RemoteArticlesState> emitter) async {
    final datastate = await _getArticleUseCase();

    if (datastate is DataSuccess && datastate.data!.isNotEmpty) {
      emit(
        RemoteArticlesDone(datastate.data!)
      );
    }

    if (datastate is DataFailed) {
      print(datastate.error!.message);
      emit(
        RemoteArticlesError(datastate.error!)
      );
    }
  }
}