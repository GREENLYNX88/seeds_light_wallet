import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/app/ecosystem/dho/dho.dart';
import 'package:seeds/screens/app/ecosystem/guardians/guardians.dart';
import 'package:seeds/screens/app/ecosystem/harvest/plant_seeds.dart';
import 'package:seeds/screens/app/ecosystem/invites/create_invite.dart';
import 'package:seeds/screens/app/ecosystem/invites/invites.dart';
import 'package:seeds/screens/app/ecosystem/proposals/proposal_details.dart';
import 'package:seeds/screens/app/ecosystem/proposals/proposals.dart';
import 'package:seeds/screens/app/guardians/guardian_invite.dart';
import 'package:seeds/screens/app/guardians/guardian_invite_sent.dart';
import 'package:seeds/screens/app/guardians/guardians_tabs.dart';
import 'package:seeds/screens/app/guardians/select_guardians.dart';
import 'package:seeds/screens/app/profile/image_viewer.dart';
import 'package:seeds/screens/app/profile/logout.dart';
import 'package:seeds/screens/app/wallet/dashboard/dashboard.dart';
import 'package:seeds/screens/app/wallet/receive.dart';
import 'package:seeds/screens/app/wallet/receive_confirmation.dart';
import 'package:seeds/screens/app/wallet/receive_custom.dart';
import 'package:seeds/screens/app/wallet/receive_qr.dart';
import 'package:seeds/screens/app/wallet/transfer/transfer.dart';
import 'package:seeds/screens/app/wallet/transfer/transfer_form.dart';
import 'package:seeds/screens/onboarding/join_process.dart';
import 'package:seeds/v2/screens/create_username/create_username.dart';
import 'package:seeds/v2/screens/explore/explore_screen.dart';
import 'package:seeds/v2/screens/import_key/import_key_screen.dart';
import 'package:seeds/v2/screens/login/login_screen.dart';
import 'package:seeds/v2/screens/passcode/passcode_screen.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/citizenship_screen.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/contribution_screen.dart';
import 'package:seeds/v2/screens/profile_screens/edit_name/edit_name_screen.dart';
import 'package:seeds/v2/screens/profile_screens/security/security_screen.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/set_currency_screen.dart';
import 'package:seeds/v2/screens/profile_screens/support/support_screen.dart';
import 'package:seeds/v2/screens/send_confirmation/send_confirmation_screen.dart';
import 'package:seeds/v2/screens/send_scanner/send_scanner_screen.dart';
import 'package:seeds/widgets/page_not_found.dart';

class Routes {
  static final app = 'App';
  static final transferForm = 'TransferForm';
  static final onboarding = 'Onboarding';
  static final joinProcess = 'JoinProcess';
  static final createAccount = 'CreateAccount';
  static final showInvite = 'ShowInvite';
  static final claimCode = 'ClaimCode';
  static final welcome = 'Welcome';
  static final transfer = 'Transfer';
  static final invites = 'Invites';
  static final createInvite = 'CreateInvite';
  static final proposals = 'Proposals';
  static final proposalDetailsPage = 'ProposalDetailsPage';
  static final overview = 'Overview';
  static final explore = 'Explore';
  static final dashboard = 'Dashboard';
  static final logout = 'Logout';
  static final imageViewer = 'ImageViewer';
  static final plantSeeds = 'plantSeeds';
  static final sendConfirmationScreen = 'SendConfirmationScreen';
  static final scanQRCode = 'ScanQRCode';
  static final receive = 'Receive';
  static final receiveConfirmation = 'ReceiveConfirmation';
  static final receiveCustom = 'ReceiveCustom';
  static final receiveQR = 'ReceiveQR';
  static final selectGuardians = 'SelectGuardians';
  static final inviteGuardians = 'InviteGuardians';
  static final inviteGuardiansSent = 'InviteGuardiansSent';
  static final guardianTabs = 'GuardianTabs';
  static final dho = 'DHO';
  static final guardians = 'Guardians';
  static final support = 'Support';
  static final security = 'Security';
  static final editName = 'EditName';
  static final setCurrency = "SetCurrency";
  static final citizenship = 'CitizenShip';
  static final contribution = 'Contribution';
  static final login = "Login";
  static final importKey = "ImportKey";
  static final passcode = "passcode";
  static final createUsername = "createUsername";
}

class NavigationService {
  final GlobalKey<NavigatorState> onboardingNavigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> walletNavigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> ecosystemNavigatorKey = GlobalKey<NavigatorState>();

  static NavigationService of(BuildContext context, {bool listen = false}) =>
      Provider.of<NavigationService>(context, listen: listen);

  StreamController<String> streamRouteListener;

  final onboardingRoutes = {
    Routes.joinProcess: (_) => JoinProcess(),
    Routes.login: (_) => LoginScreen(),
    Routes.importKey: (_) => const ImportKeyScreen(),
    Routes.createUsername: (_) => CreateUsername(),
    // Routes.importAccount: (_) => ImportAccount(),
    // Routes.createAccount: (args) => CreateAccount(args),
    // Routes.showInvite: (args) => ShowInvite(args),
    // Routes.claimCode: (_) => ClaimCode(),
    // Routes.welcome: (args) => Welcome(args),
  };

  final appRoutes = {
    Routes.app: (_) => App(),
    Routes.transferForm: (args) => TransferForm(args),
    Routes.transfer: (_) => Transfer(),
    Routes.invites: (_) => Invites(),
    Routes.createInvite: (_) => CreateInvite(),
    Routes.proposals: (_) => Proposals(),
    Routes.proposalDetailsPage: (args) => ProposalDetailsPage(proposal: args),
    Routes.logout: (_) => Logout(),
    Routes.imageViewer: (args) => ImageViewer(
          arguments: args,
        ),
    Routes.plantSeeds: (_) => PlantSeeds(),
    Routes.sendConfirmationScreen: (args) => const SendConfirmationScreen(),
    Routes.scanQRCode: (_) => SendScannerScreen(),
    Routes.receive: (_) => Receive(),
    Routes.receiveConfirmation: (args) => ReceiveConfirmation(cart: args),
    Routes.receiveCustom: (_) => ReceiveCustom(),
    Routes.receiveQR: (args) => ReceiveQR(amount: args),
    Routes.selectGuardians: (_) => SelectGuardians(),
    Routes.inviteGuardians: (args) => InviteGuardians(args),
    Routes.inviteGuardiansSent: (_) => InviteGuardiansSent(),
    Routes.guardianTabs: (_) => GuardianTabs(),
    Routes.dho: (_) => DHO(),
    Routes.guardians: (_) => Guardians(),
    Routes.support: (_) => const SupportScreen(),
    Routes.security: (_) => const SecurityScreen(),
    Routes.editName: (_) => const EditNameScreen(),
    Routes.setCurrency: (_) => const SetCurrencyScreen(),
    Routes.citizenship: (_) => const CitizenshipScreen(),
    Routes.contribution: (_) => const ContributionScreen(),
    Routes.passcode: (_) => const PasscodeScreen(),
  };

  final ecosystemRoutes = {
    Routes.explore: (_) => ExploreScreen(),
  };

  final walletRoutes = {
    Routes.dashboard: (_) => Dashboard(),
  };

  void addListener(StreamController<String> listener) {
    streamRouteListener = listener;
  }

  Future<dynamic> navigateTo(String routeName, [Object arguments, bool replace = false]) async {
    var navigatorKey;

    if (streamRouteListener != null) {
      streamRouteListener.add(routeName);
    }

    if (appRoutes[routeName] != null) {
      navigatorKey = appNavigatorKey;
    } else if (walletRoutes[routeName] != null) {
      navigatorKey = walletNavigatorKey;
    } else if (ecosystemRoutes[routeName] != null) {
      navigatorKey = ecosystemNavigatorKey;
    } else if (onboardingRoutes[routeName] != null) {
      navigatorKey = onboardingNavigatorKey;
    }

    if (navigatorKey.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (replace) {
      return navigatorKey.currentState.pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
    }
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    var routeName = settings.name;
    var arguments = settings.arguments;

    if (appRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => appRoutes[routeName](arguments),
      );
    } else if (onboardingRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => onboardingRoutes[routeName](arguments),
      );
    } else if (ecosystemRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ecosystemRoutes[routeName](arguments),
      );
    } else if (walletRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => walletRoutes[routeName](arguments),
      );
    } else {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => PageNotFound(
          routeName: settings.name,
          args: settings.arguments,
        ),
      );
    }
  }

  static RoutePredicate predicateForName(String name) {
    return (Route<dynamic> route) {
      //print("Route: ${route.settings.name}" + " modal: ${route is ModalRoute} handlepop: ${route.willHandlePopInternally}");
      if (route.settings.name == '/' && name != '/') {
        print('pop error: Route name not found: ' + name);
      }
      return !route.willHandlePopInternally && route is ModalRoute && route.settings.name == name ||
          route.settings.name == '/';
    };
  }
}
