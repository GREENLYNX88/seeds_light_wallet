import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';

class RecoverAccountFoundState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String userAccount;
  final Uri? linkToActivateGuardians;
  final List<String> alreadySignedGuardians;
  final List<MemberModel> userGuardiansData;
  final int confirmedGuardianSignatures;
  final RecoveryStatus recoveryStatus;
  final int timeLockExpirySeconds;
  final CurrentRemainingTime? currentRemainingTime;
  final PageCommand? pageCommand;

  int get timeRemaining => timeLockExpirySeconds - DateTime.now().millisecondsSinceEpoch ~/ 1000;

  const RecoverAccountFoundState({
    required this.pageState,
    required this.linkToActivateGuardians,
    required this.userGuardiansData,
    this.errorMessage,
    required this.confirmedGuardianSignatures,
    required this.recoveryStatus,
    required this.alreadySignedGuardians,
    required this.timeLockExpirySeconds,
    this.currentRemainingTime,
    required this.userAccount,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        linkToActivateGuardians,
        userGuardiansData,
        errorMessage,
        confirmedGuardianSignatures,
        recoveryStatus,
        alreadySignedGuardians,
        timeLockExpirySeconds,
        userAccount,
        pageCommand,
        currentRemainingTime,
      ];

  RecoverAccountFoundState copyWith({
    PageState? pageState,
    Uri? linkToActivateGuardians,
    List<String>? userGuardians,
    List<MemberModel>? userGuardiansData,
    String? errorMessage,
    int? confirmedGuardianSignatures,
    List<String>? alreadySignedGuardians,
    RecoveryStatus? recoveryStatus,
    int? timeLockExpirySeconds,
    CurrentRemainingTime? currentRemainingTime,
    PageCommand? pageCommand,
  }) {
    return RecoverAccountFoundState(
      pageState: pageState ?? this.pageState,
      linkToActivateGuardians: linkToActivateGuardians ?? this.linkToActivateGuardians,
      userGuardiansData: userGuardiansData ?? this.userGuardiansData,
      errorMessage: errorMessage,
      confirmedGuardianSignatures: confirmedGuardianSignatures ?? this.confirmedGuardianSignatures,
      recoveryStatus: recoveryStatus ?? this.recoveryStatus,
      alreadySignedGuardians: alreadySignedGuardians ?? this.alreadySignedGuardians,
      timeLockExpirySeconds: timeLockExpirySeconds ?? this.timeLockExpirySeconds,
      currentRemainingTime: currentRemainingTime ?? this.currentRemainingTime,
      userAccount: userAccount,
      pageCommand: pageCommand,
    );
  }

  factory RecoverAccountFoundState.initial(String userAccount) {
    return RecoverAccountFoundState(
      pageState: PageState.initial,
      linkToActivateGuardians: null,
      userGuardiansData: [],
      confirmedGuardianSignatures: 0,
      recoveryStatus: RecoveryStatus.WAITING_FOR_GUARDIANS_TO_SIGN,
      alreadySignedGuardians: [],
      timeLockExpirySeconds: 0,
      userAccount: userAccount,
    );
  }
}

enum RecoveryStatus {
  WAITING_FOR_GUARDIANS_TO_SIGN,
  WAITING_FOR_24_HOUR_COOL_PERIOD,
  READY_TO_CLAIM_ACCOUNT,
}
