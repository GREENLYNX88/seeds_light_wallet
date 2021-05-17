import 'package:flutter/material.dart';
import 'package:seeds/design/app_theme.dart';

class AmountEntryWidget extends StatelessWidget {
  final String? fiatAmount;
  final ValueSetter<String> onValueChange;
  final String enteringCurrencyName;
  final bool autoFocus;

  const AmountEntryWidget({
    Key? key,
    this.fiatAmount,
    required this.onValueChange,
    required this.enteringCurrencyName,
    required this.autoFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextFormField(
                textAlign: TextAlign.end,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline4,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "0.0",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                autofocus: autoFocus,
                onChanged: (String value) => onValueChange(value),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Text(
                        enteringCurrencyName,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      const SizedBox(height: 18)
                    ],
                  ),
                  Positioned(
                    bottom: -16,
                    left: 70,
                    child: Container(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        icon: Image.asset('assets/images/currency_switch_button.png'),
                        onPressed: () => () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Text(
          fiatAmount != null ? "\$" + fiatAmount! : "",
          style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
        ),
      ],
    );
  }
}
