/// Constants da API do FakeStore - docs aqui https://fakestoreapi.com/docs
/// Timeout em 5 segundos - ideal seria usar Dio RetryInterceptor ou backoff + jitter
class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String userAgent = 'GoodBuy App ;3 (Flutter; +https://github.com/hkAlice)';
  static const int timeout = 5;
}
