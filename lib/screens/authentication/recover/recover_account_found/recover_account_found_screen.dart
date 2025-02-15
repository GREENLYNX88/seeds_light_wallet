import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/components/text_form_field_custom.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/authentication/recover/recover.i18n.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/components/guardian_row_widget.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/recover_account_found_bloc.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_events.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_page_command.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';
import 'package:share/share.dart';

class RecoverAccountFoundScreen extends StatelessWidget {
  const RecoverAccountFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: cast_nullable_to_non_nullable
    final String userAccount = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (_) =>
          RecoverAccountFoundBloc(userAccount, BlocProvider.of<AuthenticationBloc>(context))..add(FetchInitialData()),
      child: BlocConsumer<RecoverAccountFoundBloc, RecoverAccountFoundState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<RecoverAccountFoundBloc>(context).add(const ClearRecoverPageCommand());

          if (pageCommand is ShowLinkCopied) {
            SnackBarInfo("Copied".i18n, ScaffoldMessenger.of(context)).show();
          } else if (pageCommand is ShowErrorMessage) {
            SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
          } else if (pageCommand is CancelRecoveryProcess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Padding(padding: const EdgeInsets.only(left: 16), child: Text("Recover Account".i18n)),
                  automaticallyImplyLeading: false,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => BlocProvider.of<RecoverAccountFoundBloc>(context).add(OnRefreshTap()),
                      ),
                    )
                  ],
                ),
                body: buildBody(state, context)),
          );
        },
      ),
    );
  }

  Widget buildBody(RecoverAccountFoundState state, BuildContext context) {
    switch (state.pageState) {
      case PageState.initial:
        return const SizedBox.shrink();
      case PageState.loading:
        return const FullPageLoadingIndicator();
      case PageState.failure:
        return FullPageErrorIndicator(
          errorMessage: state.errorMessage,
          buttonTitle: "Cancel Process".i18n,
          buttonOnPressed: () => BlocProvider.of<RecoverAccountFoundBloc>(context).add(OnCancelProcessTap()),
        );
      case PageState.success:
        switch (state.recoveryStatus) {
          case RecoveryStatus.WAITING_FOR_GUARDIANS_TO_SIGN:
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                          child: TextFormFieldCustom(
                            enabled: false,
                            labelText: 'Link to Activate Key Guardians'.i18n,
                            suffixIcon: const SizedBox.shrink(),
                            controller: TextEditingController(text: state.linkToActivateGuardians?.toString()),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8, top: 8),
                            child: IconButton(
                              icon: const Icon(Icons.share, color: AppColors.white),
                              splashRadius: 30,
                              onPressed: () async {
                                await Share.share(state.linkToActivateGuardians!.toString());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(state.confirmedGuardianSignatures.toString(),
                              style: Theme.of(context).textTheme.button1),
                          Text("/${state.userGuardiansData.length}", style: Theme.of(context).textTheme.button1),
                          const SizedBox(width: 24),
                          Flexible(
                            child: Text(
                              "Guardians have accepted your request to recover your account".i18n,
                              style: Theme.of(context).textTheme.buttonLowEmphasis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0), child: DividerJungle()),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: state.userGuardiansData
                            .map((e) => GuardianRowWidget(
                                  guardianModel: e,
                                  showGuardianSigned: state.alreadySignedGuardians
                                      .where((String element) => element == e.account)
                                      .isNotEmpty,
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FlatButtonLong(
                        title: "Cancel Process".i18n,
                        onPressed: () => BlocProvider.of<RecoverAccountFoundBloc>(context).add(OnCancelProcessTap()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          default:
            return Scaffold(
              bottomSheet: Padding(
                padding: const EdgeInsets.all(horizontalEdgePadding),
                child: FlatButtonLong(
                  enabled: state.recoveryStatus == RecoveryStatus.READY_TO_CLAIM_ACCOUNT,
                  title: "Claim account".i18n,
                  onPressed: () => BlocProvider.of<RecoverAccountFoundBloc>(context).add(OnClaimAccountTap()),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalEdgePadding),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "All three of your Key Guardians have accepted your request to recover your account. \n You account will be unlocked in 24hrs. "
                                .i18n,
                            style: Theme.of(context).textTheme.subtitle2LowEmphasis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Image(image: AssetImage('assets/images/guardians/check_circle.png')),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(state.currentRemainingTime?.hoursFormatted ?? '00',
                                    style: Theme.of(context).textTheme.headline4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(':', style: Theme.of(context).textTheme.headline4),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(state.currentRemainingTime?.minFormatted ?? '00',
                                    style: Theme.of(context).textTheme.headline4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(':', style: Theme.of(context).textTheme.headline4),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text('${state.currentRemainingTime?.secFormatted ?? '00'} ',
                                    style: Theme.of(context).textTheme.headline4),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Text("Hours Left".i18n, style: Theme.of(context).textTheme.subtitle2),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (state.recoveryStatus == RecoveryStatus.READY_TO_CLAIM_ACCOUNT)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Account recovered '.i18n), Text(state.userAccount)],
                          ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
    }
  }
}
