import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/cupertino.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.height,
    this.radius,
    this.color,
    this.width,
  });
  final double? height, width;
  final double? radius;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 100,
      width: width,
      child: Center(
        child: CupertinoActivityIndicator(
          color: color ?? AppColor.appWhite,
          radius: radius ?? 20,
        ),
      ),
    );
  }
}
