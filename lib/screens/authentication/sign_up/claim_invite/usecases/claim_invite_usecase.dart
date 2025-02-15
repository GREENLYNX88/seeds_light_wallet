import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/invite_repository.dart';
import 'package:seeds/datasource/remote/api/signup_repository.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

class ClaimInviteUseCase {
  final SignupRepository _signupRepository;

  ClaimInviteUseCase(SignupRepository signupRepository) : _signupRepository = signupRepository;

  Future<Result> validateInviteCode(String inviteCode) {
    final String inviteSecret = secretFromMnemonic(inviteCode);
    final String inviteHash = hashFromSecret(inviteSecret);
    return InviteRepository().findInvite(inviteHash);
  }

  Future<Result> unpackLink(String link) {
    return _signupRepository.unpackDynamicLink(link);
  }
}
