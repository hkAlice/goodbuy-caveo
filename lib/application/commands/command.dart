abstract class Command<T> {
  /// Executes the command and returns a Result containing either the successful data or an error.
  Future<Result<T>> execute();
}

class Result<T> {
  final T? data;
  final Object? error;
  final StackTrace? stackTrace;
  final bool isSuccess;

  Result.success(this.data)
      : error = null,
        stackTrace = null,
        isSuccess = true;

  Result.error(this.error, this.stackTrace)
      : data = null,
        isSuccess = false;

  T getOrThrow() {
    if (isSuccess && data != null) {
      return data!;
    }
    throw error ?? Exception('Erro desconhecido');
  }

  Result<R> map<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      try {
        return Result.success(mapper(data as T));
      } catch (e, s) {
        return Result.error(e, s);
      }
    }
    return Result.error(error, stackTrace);
  }
}
