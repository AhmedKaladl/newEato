import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class DeliveryDetails extends StatelessWidget {
  final bool from;
  final String? address;
  const DeliveryDetails({Key? key, this.from = true, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Icon(from ? Icons.store : Icons.location_on, size: 28, color: from ? Colors.blue : Theme.of(context).primaryColor),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(from ? 'from_restaurant'.tr : 'to'.tr, style: IBMPlexSansArabicMedium),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(
          address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
          style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).disabledColor),
        )
      ])),
    ]);
  }
}
