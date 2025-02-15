import 'package:flutter/material.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/components/components.i18n.dart';

class FullPageErrorIndicator extends StatelessWidget {
  final String? errorMessage;
  final String? buttonTitle;
  final VoidCallback? buttonOnPressed;

  const FullPageErrorIndicator({this.errorMessage, this.buttonTitle, this.buttonOnPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: Center(
          child: Text(
            errorMessage ?? "Oops, Something Went Wrong".i18n,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(color: AppColors.red1),
          ),
        ),
      ),
      if (buttonTitle != null && buttonOnPressed != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: FlatButtonLong(title: buttonTitle!, onPressed: buttonOnPressed),
        ),
    ]);
  }
}
