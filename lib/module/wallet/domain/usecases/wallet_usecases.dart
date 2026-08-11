import '../repositories/wallet_repository.dart';

class AddMoneyToWalletUseCase {
  final WalletRepository repository;
  AddMoneyToWalletUseCase(this.repository);
  Future<void> execute(String userId, String amount) => repository.updateWallet(userId, amount);
}
