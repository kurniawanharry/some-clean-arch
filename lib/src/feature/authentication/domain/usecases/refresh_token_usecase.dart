import 'package:some_app/src/feature/authentication/domain/repositories/abstract_token_repo.dart';

class RefreshTokenUseCase {
  final AbstractTokenRepository _repository;

  RefreshTokenUseCase(this._repository);

  Future<String?> execute() async {
    try {
      return await _repository.refreshToken();
    } catch (e) {
      // Handle error, e.g., log, throw custom exception, etc.
      print('Error refreshing token: $e');
      return null;
    }
  }
}
