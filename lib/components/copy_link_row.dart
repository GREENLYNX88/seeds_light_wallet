import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeds/components/snack_bar_info.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/i18n/components/components.i18n.dart';

/// Copy Link
///
/// Used to display a row with a Hash and a copy Icon at the end

class ShareLinkRow extends StatelessWidget {
  final String label;
  final String link;

  const ShareLinkRow({Key? key, required this.label, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.subtitle2HighEmphasis),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            link,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle2HighEmphasis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          color: AppColors.white,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: link))
                .then((_) => SnackBarInfo("Copied".i18n, ScaffoldMessenger.of(context)).show());
          },
        )
      ],
    );
  }
}
