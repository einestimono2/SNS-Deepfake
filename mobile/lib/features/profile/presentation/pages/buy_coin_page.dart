import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../blocs/blocs.dart';

class BuyCoinPage extends StatefulWidget {
  const BuyCoinPage({super.key});

  @override
  State<BuyCoinPage> createState() => _BuyCoinPageState();
}

class _BuyCoinPageState extends State<BuyCoinPage> {
  final double py = 12;

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  void _handleBuyCoins(int amount) {
    _loading.value = true;

    context.read<ProfileActionBloc>().add(BuyCoinSubmit(
          amount: amount,
          onSuccess: () => _loading.value = false,
          onError: (msg) {
            _loading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = (1.sw - py * 2) / 2 - 6;

    return ValueListenableBuilder(
      valueListenable: _loading,
      builder: (context, value, child) => Stack(
        children: [
          SliverPage(
            title: "BUY_COINS_TEXT".tr(),
            centerTitle: true,
            actions: [_numCoins()],
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: py),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SectionTitle(
                        title: "DISCOUNT_TEXT".tr(),
                        margin: const EdgeInsets.only(bottom: 6),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _card(cardWidth, 50, 50000, 0.85),
                          _card(cardWidth, 100, 10000, 0.75),
                        ],
                      ),

                      /*  */
                      SectionTitle(
                        title: "COIN_PACKAGES_TEXT".tr(),
                        margin: const EdgeInsets.only(bottom: 6, top: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _card(cardWidth, 10, 10000),
                          _card(cardWidth, 20, 20000),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _card(cardWidth, 50, 50000),
                          _card(cardWidth, 100, 100000),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _card(cardWidth, 200, 200000),
                          _card(cardWidth, 500, 500000),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              )
            ],
          ),

          /*  */
          if (value)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.blueGrey.withOpacity(0.35),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    "LOADING_PROGRESS_TEXT".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _card(double width, int num, double price, [double discount = 1]) {
    Widget _content = Container(
      width: width,
      constraints: BoxConstraints(minHeight: width),
      decoration: BoxDecoration(
        color: context.minBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
        boxShadow: highModeShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Icon(
            FontAwesomeIcons.coins,
            size: 64,
            color: Colors.yellow,
          ),
          const SizedBox(height: 12),
          Text(
            num.toString(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: width - 24,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6),
              ),
              onPressed: () => _handleBuyCoins(num),
              child: Text(
                Formatter.formatCurrency(
                  price * discount,
                  context.locale.languageCode,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        ],
      ),
    );

    return discount == 1
        ? _content
        : Stack(
            children: [
              _content,
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    "${discount * 100}%",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          );
  }

  BlocBuilder<AppBloc, AppState> _numCoins() {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
          decoration: BoxDecoration(
            color: context.minBackgroundColor(),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                FontAwesomeIcons.coins,
                size: 16,
                color: Colors.yellow,
              ),
              const SizedBox(width: 6),
              Text(
                "NUM_COINS_TEXT".plural(state.user?.coins ?? 0),
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ],
          ),
        );
      },
    );
  }
}
