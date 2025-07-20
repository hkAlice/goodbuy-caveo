// todo: achar lugar melhor :3 (talvez /application/?)
abstract class Command<T> {
  Future<T> execute();
}
