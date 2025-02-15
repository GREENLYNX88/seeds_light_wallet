part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

class OnExploreCardTapped extends ExploreEvent {
  final String route;

  const OnExploreCardTapped(this.route);

  @override
  String toString() => 'OnExploreCardTapped { route: $route }';
}

class ClearExplorePageCommand extends ExploreEvent {
  const ClearExplorePageCommand();

  @override
  String toString() => 'ClearExplorePageCommand';
}
