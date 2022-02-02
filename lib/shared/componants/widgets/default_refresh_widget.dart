import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DefaultRefreshWidget extends StatelessWidget {
  DefaultRefreshWidget({Key? key,
    required this.child,
    required this.refreshController,
    required this.onRefresh,
    required this.enablePullUp,
    this.onLoading,
  }) : super(key: key);

  final Widget child;
  final RefreshController refreshController;
  final Function() onRefresh;
  Function()? onLoading;
  final bool enablePullUp;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: enablePullUp,
      header: WaterDropHeader(),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
