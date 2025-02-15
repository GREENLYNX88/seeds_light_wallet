import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/authentication/sign_up/sign_up.i18n.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/bloc.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/utils/string_extension.dart';

class ClaimInviteMapper extends StateMapper {
  SignupState mapValidateInviteCodeToState(SignupState currentState, Result result) {
    final claimInviteCurrentState = currentState.claimInviteState;

    if (result.isError) {
      return currentState.copyWith(
        claimInviteState: claimInviteCurrentState.copyWith(
          claimInviteView: ClaimInviteView.fail, // gray screen
          pageCommand: ShowErrorMessage(''), // dialog
          errorMessage: 'No invites found, try another code'.i18n,
        ),
      );
    } else {
      final InviteModel inviteModel = result.asValue!.value;

      if (!inviteModel.isClaimed) {
        // invite code is valid and can be claimed
        return currentState.copyWith(
          claimInviteState: claimInviteCurrentState.copyWith(
            claimInviteView: ClaimInviteView.success,
            inviteModel: inviteModel,
          ),
        );
      } else {
        // invite code is valid but claimed before
        return currentState.copyWith(
          claimInviteState: claimInviteCurrentState.copyWith(
            claimInviteView: ClaimInviteView.fail, // gray screen
            pageCommand: ShowErrorMessage(''), // dialog
            errorMessage: 'Invite was already claimed'.i18n.fill(
              [inviteModel.sponsor, inviteModel.account ?? ''],
            ),
          ),
        );
      }
    }
  }

  SignupState mapInviteMnemonicToState(SignupState currentState, Result result) {
    final claimInviteCurrentState = currentState.claimInviteState;

    if (result.isError) {
      return currentState.copyWith(
        claimInviteState: claimInviteCurrentState.copyWith(
          claimInviteView: ClaimInviteView.fail, // gray screen
          pageCommand: ShowErrorMessage(''), // dialog
          errorMessage: result.asError!.error.toString(),
        ),
      );
    } else {
      final String inviteMnemonic = result.asValue!.value;

      return currentState.copyWith(
        claimInviteState: claimInviteCurrentState.copyWith(
          claimInviteView: ClaimInviteView.processing,
          inviteMnemonic: inviteMnemonic,
          pageCommand: !inviteMnemonic.isNullOrEmpty ? StopScan() : null,
        ),
      );
    }
  }
}
