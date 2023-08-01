# flutter_clean_architecture
<img width="300" alt="image" src="https://github.com/YamamotoDesu/flutter_clean_architecture/assets/47273077/e47021d0-19ac-404b-b47d-6fadf1360ed5">

```
- lib
  - config
    - routes
    - theme
  - core
    - constants
    - error
    - network
    - resources
    - usecases
    - utils
  - fetures
    - sample
      - data
        - data_sources
        - models
        - repository
      - domain
        - entities
        - repository
        - usecases
      - presentation
        - bloc
        - pages
  - injection_container.dart
  - main.dart
```

pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2

  #flutter bloc
  flutter_bloc: ^8.1.2

  #comparing dart objects
  equatable: ^2.0.5

  #service locator
  get_it: ^7.6.0

  #dateFormatter
  intl: ^0.18.1

  #Databse
  floor: ^1.4.2

  #hooks
  flutter_hooks: ^0.18.3

  #chached image
  cached_network_image: ^3.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^1.0.0
  retrofit_generator: ^3.0.1+1
  floor_generator: 1.2.0
  build_runner: 2.1.2

flutter:

  flutter_lints: ^2.0.0

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  fonts:
  - family: Muli
    fonts:
      - asset: assets/fonts/muli/Muli.ttf
      - asset: assets/fonts/muli/Muli-Bold.ttf
        weight: 700
      - asset: assets/fonts/muli/Muli-Light.ttf
        weight: 300
```

## Presentation Layer
```
- presentaion
        - bloc
          - article
            - remote
              - remote_article_bloc.dart
              - remote_article_event.dart
              - remote_article_state.dart
        - pages
          - home
            - daily_news.dart
        - widgets
          - article_tile.dart
```

lib/fetures/daily_news/presentaion/pages/home/daily_news.dart
```dart
class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  _buildAppbar() {
    return AppBar(
      title: const Text(
        "Daily News",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  _buildBody() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (_, state) {
        if (state is RemoteArticlesLoading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        if (state is RemoteArticlesError) {
          return const Center(
            child: Icon(Icons.refresh),
          );
        }

        if (state is RemoteArticlesDone) {
          return ListView.builder(
            itemBuilder: (contex, index) {
              return ArticleWidget(article: state.articles![index]);
            },
            itemCount: state.articles!.length,
          );
        }
        return const SizedBox();
      },
    );
  }
}
```

lib/fetures/daily_news/presentaion/bloc/article/remote/remote_article_state.dart
```dart
abstract class RemoteArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  final DioException? error;

  const RemoteArticlesState({this.articles, this.error});

  @override
  List<Object> get props => [articles!, error!];
}

class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

class RemoteArticlesDone extends RemoteArticlesState {
  const RemoteArticlesDone(List<ArticleEntity> articles) : super(articles: articles);
}

class RemoteArticlesError extends RemoteArticlesState {
  const RemoteArticlesError(DioException error) : super(error: error);
}
```

lib/fetures/daily_news/presentaion/bloc/article/remote/remote_article_event.dart
```dart
abstract class RemoteArticlesEvent {
  const RemoteArticlesEvent();
}

class GetArticles extends RemoteArticlesEvent {
  const GetArticles();
}
```

lib/fetures/daily_news/presentaion/bloc/article/remote/remote_article_bloc.dart
```dart

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
```
