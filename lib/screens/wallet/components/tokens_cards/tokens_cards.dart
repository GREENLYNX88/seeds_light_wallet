import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/wallet/components/receive_send_buttons.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/components/currency_info_card.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/wallet_bloc.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/wallet_state.dart';
import 'interactor/viewmodels/token_balances_bloc.dart';
import 'interactor/viewmodels/token_balances_event.dart';
import 'interactor/viewmodels/token_balances_state.dart';

class TokenCards extends StatefulWidget {
  const TokenCards({Key? key}) : super(key: key);

  @override
  _TokenCardsState createState() => _TokenCardsState();
}

class _TokenCardsState extends State<TokenCards> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => TokenBalancesBloc()..add(const OnLoadTokenBalances()),
      child: BlocListener<WalletBloc, WalletState>(
        listenWhen: (_, current) => current.pageState == PageState.loading,
        listener: (context, _) {
          BlocProvider.of<TokenBalancesBloc>(context).add(const OnLoadTokenBalances());
        },
        child: BlocBuilder<TokenBalancesBloc, TokenBalancesState>(
          builder: (context, state) {
            return Column(
              children: [
                SingleChildScrollView(
                  child: CarouselSlider(
                    items: [
                      for (var tokenBalanceViewModel in state.availableTokens)
                        Container(
                          margin: EdgeInsets.only(
                              left: tokenBalanceViewModel.token == state.availableTokens.first.token ? 0 : 10.0,
                              right: tokenBalanceViewModel.token == state.availableTokens.last.token ? 0 : 10.0),
                          child: CurrencyInfoCard(
                            tokenBalanceViewModel,
                            fiatBalance:
                                tokenBalanceViewModel.fiatValueString(BlocProvider.of<RatesBloc>(context).state),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      height: 220,
                      viewportFraction: 0.89,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, _) {
                        BlocProvider.of<TokenBalancesBloc>(context).add(OnSelectedTokenChanged(index));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DotsIndicator(
                  dotsCount: state.availableTokens.length,
                  position: state.selectedIndex.toDouble(),
                  decorator: const DotsDecorator(
                    spacing: EdgeInsets.all(2.0),
                    size: Size(10.0, 2.0),
                    shape: Border(),
                    color: AppColors.darkGreen2,
                    activeColor: AppColors.green1,
                    activeSize: Size(18.0, 2.0),
                    activeShape: Border(),
                  ),
                ),
                const SizedBox(height: 20),
                const ReceiveSendButtons(),
              ],
            );
          },
        ),
      ),
    );
  }
}
