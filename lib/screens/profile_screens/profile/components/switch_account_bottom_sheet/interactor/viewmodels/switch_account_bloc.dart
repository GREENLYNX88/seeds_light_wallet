import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/screens/authentication/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/mappers/find_accounts_result_state_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/mappers/set_private_key_state_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/usecases/get_public_key_from_account_use_case%20copy.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/usecases/import_accounts_use_case.dart';

part 'switch_account_event.dart';
part 'switch_account_state.dart';

class SwitchAccountBloc extends Bloc<SwitchAccountEvent, SwitchAccountState> {
  final AuthenticationBloc _authenticationBloc;
  SwitchAccountBloc(this._authenticationBloc, isRecoverPharseEnabled)
      : super(SwitchAccountState.initial(isRecoverPharseEnabled));

  @override
  Stream<SwitchAccountState> mapEventToState(SwitchAccountEvent event) async* {
    if (event is FindAccountsByKey) {
      yield state.copyWith(pageState: PageState.loading);
      final List<Keys> keys = settingsStorage.privateKeysList
          .map((i) => Keys(publicKey: CheckPrivateKeyUseCase().isKeyValid(i), privateKey: i))
          .toList();
      final List<String?> publicKeys = keys.map((i) => i.publicKey).toList();
      if (publicKeys.contains(null) || publicKeys.contains('')) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: "Private key is not valid".i18n);
      } else {
        final results = await ImportAccountsUseCase().run(publicKeys as List<String>);
        yield FindAccountsResultStateMapper().mapResultsToState(state, results, keys);
      }
    } else if (event is OnAccountSelected) {
      yield state.copyWith(currentAcccout: event.profile);
      final result = await GetPublicKeyFromAccountUseCase().run(event.profile.account);
      yield SetFoundPrivateKeyStateMapper().mapResultToState(state, result);
      // Only refresh the current accountName and the privateKey, then fire auth.
      _authenticationBloc.add(OnSwitchAccount(event.profile.account, state.authDataModel!));
    }
  }
}

class Keys {
  final String? publicKey;
  final String privateKey;
  const Keys({required this.publicKey, required this.privateKey});
}
