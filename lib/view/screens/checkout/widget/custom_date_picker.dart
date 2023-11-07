import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatelessWidget {
  final String hint;
  final DateTimeRange? range;
  final Function(DateTimeRange range) onDatePicked;
  final bool isPause;
  const CustomDatePicker({Key? key, required this.hint, required this.range, required this.onDatePicked, this.isPause = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTimeRange? range = await showDateRangePicker(
          context: context, firstDate: DateTime.now(), lastDate: isPause ? DateTime.parse(Get.find<OrderController>().trackModel!.subscription!.endAt!) : DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.isDesktop(context) ? 400.0 : context.width * 0.8,
                    maxHeight: ResponsiveHelper.isDesktop(context) ? context.height * 0.8 : context.height * 0.6,
                  ),
                  child: child,
                )
              ],
            );
          }
        );
        if(range != null) {
          if(range.start == range.end){
            showCustomSnackBar('start_date_and_end_date_can_not_be_same_for_subscription_order'.tr);
          }else{
            onDatePicked(range);
          }
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.3),
          // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 0.5, blurRadius: 0.5)],
        ),
        child: Row(children: [
          Expanded(
            child: Text(
              range != null ? DateConverter.dateRangeToDate(range!) : hint,
              style: IBMPlexSansArabicRegular,
            ),
          ),

          Icon(Icons.date_range_rounded, size: 24, color: range != null ? Theme.of(context).primaryColor : Theme.of(context).disabledColor),
        ]),
      ),
    );
  }
}
