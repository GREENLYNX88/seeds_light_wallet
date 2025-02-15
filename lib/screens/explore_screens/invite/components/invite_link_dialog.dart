import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/components/qr_code_generator_widget.dart';
import 'package:seeds/i18n/explore_screens/invite/invite.i18n.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_bloc.dart';

class InviteLinkDialog extends StatelessWidget {
  const InviteLinkDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InviteBloc, InviteState>(
      buildWhen: (_, current) => current.showCloseDialogButton,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            return true;
          },
          child: Center(
            child: SingleChildScrollView(
              child: CustomDialog(
                icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
                rightButtonTitle: 'Share'.i18n,
                leftButtonTitle: state.showCloseDialogButton ? 'Close'.i18n : '',
                onLeftButtonPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                onRightButtonPressed: () {
                  BlocProvider.of<InviteBloc>(context).add(const OnShareInviteLinkButtonPressed());
                },
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.tokenAmount.amountString(), style: Theme.of(context).textTheme.headline4),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 4),
                        child: Text(state.tokenAmount.symbol, style: Theme.of(context).textTheme.subtitle2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(state.fiatAmount.asFormattedString(), style: Theme.of(context).textTheme.subtitle2),
                  const SizedBox(height: 20.0),
                  QrCodeGeneratorWidget(data: state.dynamicSecretLink!, size: 254),
                  const SizedBox(height: 20.0),
                  Text(
                    'Share this link with the person you want to invite!'.i18n,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
