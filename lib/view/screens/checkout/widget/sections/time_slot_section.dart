import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/checkout/widget/time_slot_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
class TimeSlotSection extends StatelessWidget {
  final bool fromCart;
  final OrderController orderController;
  final RestaurantController restController;
  final bool tomorrowClosed;
  final bool todayClosed;
  final JustTheController tooltipController2;
  const TimeSlotSection({Key? key, required this.fromCart, required this.orderController, required this.restController, required this.tomorrowClosed, required this.todayClosed, required this.tooltipController2, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    // final tooltipController2 = JustTheController();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      (fromCart && !orderController.subscriptionOrder && restController.restaurant!.scheduleOrder!) ?  Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, spreadRadius: 1, offset: const Offset(1, 2))],
        ),
        margin: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.fontSizeDefault),
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('preference_time'.tr, style: IBMPlexSansArabicMedium),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            JustTheTooltip(
              backgroundColor: Colors.black87,
              controller: tooltipController2,
              preferredDirection: AxisDirection.right,
              tailLength: 14,
              tailBaseWidth: 20,
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('schedule_time_tool_tip'.tr,style: IBMPlexSansArabicRegular.copyWith(color: Colors.white)),
              ),
              child: InkWell(
                onTap: () => tooltipController2.showTooltip(),
                child: const Icon(Icons.info_outline),
              ),
              // child: const Icon(Icons.info_outline),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: (){
              if(ResponsiveHelper.isDesktop(context)){
                if(orderController.canShowTimeSlot){
                  orderController.showHideTimeSlot();
                } else {
                  orderController.showHideTimeSlot();
                }
              }else{
                showModalBottomSheet(
                  context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                  builder: (con) => TimeSlotBottomSheet(
                    tomorrowClosed: tomorrowClosed,
                    todayClosed: todayClosed,
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).disabledColor, width: 0.3),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              height: 50,
              child: Row(children: [
                const SizedBox(width: Dimensions.paddingSizeLarge),
                Expanded(child: Text(
                  (orderController.selectedDateSlot == 0 && todayClosed) ? 'restaurant_is_closed'.tr
                      : orderController.preferableTime.isNotEmpty ? orderController.preferableTime : 'now'.tr,
                  style: IBMPlexSansArabicRegular.copyWith(color: (orderController.selectedDateSlot == 0 && todayClosed) ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodyMedium!.color),
                )),

                Icon(Icons.access_time_filled_outlined, color: Theme.of(context).primaryColor),
                const SizedBox(width: Dimensions.paddingSizeSmall),
              ]),
            ),
          ),

          isDesktop && orderController.canShowTimeSlot ? Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
            child: TimeSlotBottomSheet(tomorrowClosed: tomorrowClosed, todayClosed: todayClosed),
          ) : const SizedBox(),

          const SizedBox(height: Dimensions.paddingSizeLarge),
        ]),
      ) : const SizedBox(),

      SizedBox(height: (fromCart && !orderController.subscriptionOrder && restController.restaurant!.scheduleOrder!) ? Dimensions.paddingSizeSmall : 0),

    ]);
  }

  Widget tobView({required BuildContext context, required String title, required bool isSelected, required Function() onTap}){
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(title, style: isSelected ? IBMPlexSansArabicBold.copyWith(color: Theme.of(context).primaryColor) : IBMPlexSansArabicMedium),
          Divider(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, thickness: isSelected ? 2 : 1),
        ],
      ),
    );
  }
}
