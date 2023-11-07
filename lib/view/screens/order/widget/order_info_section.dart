import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/body/notification_body.dart';
import 'package:efood_multivendor/data/model/response/conversation_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/data/model/response/review_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/chat/widget/image_dialog.dart';
import 'package:efood_multivendor/view/screens/order/widget/delivery_details.dart';
import 'package:efood_multivendor/view/screens/order/widget/log_dialog.dart';
import 'package:efood_multivendor/view/screens/order/widget/order_product_widget.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher_string.dart';
class OrderInfoSection extends StatelessWidget {
  final OrderModel order;
  final OrderController orderController;
  final List<String> schedules;
  final bool showChatPermission;
  const OrderInfoSection({Key? key, required this.order, required this.orderController, required this.schedules, required this.showChatPermission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool subscription = order.subscription != null;

    bool pending = order.orderStatus == AppConstants.pending;
    bool accepted = order.orderStatus == AppConstants.accepted;
    bool confirmed = order.orderStatus == AppConstants.confirmed;
    bool processing = order.orderStatus == AppConstants.processing;
    bool pickedUp = order.orderStatus == AppConstants.pickedUp;
    bool delivered = order.orderStatus == AppConstants.delivered;
    bool cancelled = order.orderStatus == AppConstants.cancelled;
    bool takeAway = order.orderType == 'take_away';
    bool cod = order.paymentMethod == 'cash_on_delivery';
    bool isDesktop = ResponsiveHelper.isDesktop(context);

    bool ongoing = (order.orderStatus != 'delivered' && order.orderStatus != 'failed'
        && order.orderStatus != 'refund_requested' && order.orderStatus != 'refunded'
        && order.orderStatus != 'refund_request_canceled');

    bool pastOrder = (order.orderStatus == 'delivered' || order.orderStatus == 'failed'
        || order.orderStatus == 'refund_requested' || order.orderStatus == 'refunded'
        || order.orderStatus == 'refund_request_canceled' ||order.orderStatus == 'canceled');

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Container(
        decoration: isDesktop ? BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
        ) : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DateConverter.isBeforeTime(order.scheduleAt) ? (!cancelled && ongoing && !subscription) ? Column(children: [

            ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(order.orderStatus == 'pending' ? Images.pendingOrderDetails : (order.orderStatus == 'confirmed' || order.orderStatus == 'processing' || order.orderStatus == 'handover')
                ? Images.preparingFoodOrderDetails : Images.animateDeliveryMan, fit: BoxFit.contain, height: 180)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('your_food_will_delivered_within'.tr, style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [

                Text(
                  DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt) < 5 ? '1 - 5'
                      : '${DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt)-5} '
                      '- ${DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt)}',
                  style: IBMPlexSansArabicBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('min'.tr, style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          ]) : const SizedBox() : const SizedBox(),

          (pastOrder) ? CustomImage(image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${order.restaurant!.coverPhoto}', height: 160, width: double.infinity)
              : const SizedBox(),

          isDesktop ? Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
            child: Text('general_info'.tr, style: IBMPlexSansArabicMedium),
          ) : const SizedBox(),
          SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),

          Container(
            decoration: !isDesktop ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
            ) : null,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              !isDesktop ? Text('general_info'.tr, style: IBMPlexSansArabicMedium) : const SizedBox(),
              SizedBox(height: !isDesktop ? Dimensions.paddingSizeLarge : 0),

              Row(children: [
                Text('${subscription ? 'subscription_id'.tr : 'order_id'.tr}:', style: IBMPlexSansArabicRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(order.id.toString(), style: IBMPlexSansArabicMedium),
                const Expanded(child: SizedBox()),

                const Icon(Icons.watch_later, size: 17),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  DateConverter.dateTimeStringToDateTime(order.createdAt!),
                  style: IBMPlexSansArabicRegular,
                ),
              ]),
              const Divider(height: Dimensions.paddingSizeLarge),

              order.scheduled == 1 ? Row(children: [
                Text('${'scheduled_at'.tr}:', style: IBMPlexSansArabicRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(DateConverter.dateTimeStringToDateTime(order.scheduleAt!), style: IBMPlexSansArabicMedium),
              ]) : const SizedBox(),
              order.scheduled == 1 ? const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),

              Get.find<SplashController>().configModel!.orderDeliveryVerification! ? Row(children: [
                Text('${'delivery_verification_code'.tr}:', style: IBMPlexSansArabicRegular),
                const Expanded(child: SizedBox()),
                Text(order.otp!, style: IBMPlexSansArabicMedium),
              ]) : const SizedBox(),
              Get.find<SplashController>().configModel!.orderDeliveryVerification! ?const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),

              Row(children: [
                Text(order.orderType!.tr, style: IBMPlexSansArabicMedium),
                const Expanded(child: SizedBox()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(
                    cod ? 'cash_on_delivery'.tr : order.paymentMethod == 'wallet'
                        ? 'wallet_payment'.tr : order.paymentMethod == 'partial_payment'
                        ? 'partial_payment'.tr : 'digital_payment'.tr,
                    style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
              ]),
              const Divider(height: Dimensions.paddingSizeLarge),

              subscription ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Row(children: [
                  Text('${'subscription_date'.tr}:', style: IBMPlexSansArabicRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    '${DateConverter.stringDateTimeToDate(order.subscription!.startAt!)} '
                        '- ${DateConverter.stringDateTimeToDate(order.subscription!.endAt!)}',
                    style: IBMPlexSansArabicMedium,
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Row(children: [
                  Text('${'subscription_type'.tr}:', style: IBMPlexSansArabicRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    order.subscription!.type!.tr,
                    style: IBMPlexSansArabicMedium,
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text('${'subscription_schedule'.tr}:', style: IBMPlexSansArabicRegular),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                SizedBox(height: 30, child: ListView.builder(
                  itemCount: schedules.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          schedules[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: IBMPlexSansArabicRegular,
                        ),
                      ]),
                    );
                  },
                )),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Expanded(child: CustomButton(
                    buttonText: 'delivery_log'.tr,
                    height: 35,
                    onPressed: () => Get.dialog(LogDialog(subscriptionID: order.subscriptionId, isDelivery: true)),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(child: CustomButton(
                    buttonText: 'pause_log'.tr,
                    height: 35,
                    onPressed: () => Get.dialog(LogDialog(subscriptionID: order.subscriptionId, isDelivery: false)),
                  )),
                ]),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                const Divider(height: Dimensions.paddingSizeLarge),
              ]) : const SizedBox(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${'item'.tr}:', style: IBMPlexSansArabicRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    orderController.orderDetails!.length.toString(),
                    style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(height: 7, width: 7, decoration: BoxDecoration(
                    color: (subscription ? order.subscription!.status == 'canceled' : (order.orderStatus == 'failed' || cancelled || order.orderStatus == 'refund_request_canceled'))
                        ? Colors.red : order.orderStatus == 'refund_requested' ? Colors.yellow : Colors.green ,
                    shape: BoxShape.circle,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    delivered ? '${'delivered_at'.tr} ${DateConverter.dateTimeStringToDateTime(order.delivered!)}'
                        : subscription ? order.subscription!.status!.tr : order.orderStatus!.tr,
                    style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                ]),
              ),
              // const Divider(height: Dimensions.paddingSizeLarge),

              Column(children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  Text('${'cutlery'.tr}: ', style: IBMPlexSansArabicRegular),
                  const Expanded(child: SizedBox()),

                  Text(
                    order.cutlery! ? 'yes'.tr : 'no'.tr,
                    style: IBMPlexSansArabicRegular,
                  ),
                ]),
              ]),

              order.unavailableItemNote != null ? Column(
                children: [
                  const Divider(height: Dimensions.paddingSizeLarge),
                  Row(children: [
                    Text('${'if_item_is_not_available'.tr}: ', style: IBMPlexSansArabicMedium),

                    Text(
                      order.unavailableItemNote!.tr,
                      style: IBMPlexSansArabicRegular,
                    ),
                  ]),
                ],
              ) : const SizedBox(),

              order.deliveryInstruction != null ? Column(children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  Text('${'delivery_instruction'.tr}: ', style: IBMPlexSansArabicMedium),

                  Text(
                    order.deliveryInstruction!.tr,
                    style: IBMPlexSansArabicRegular,
                  ),
                ]),
              ]) : const SizedBox(),
              SizedBox(height: order.deliveryInstruction != null ? Dimensions.paddingSizeSmall : 0),

              cancelled ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),
                Text('${'cancellation_reason'.tr}:', style: IBMPlexSansArabicMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialog(review: ReviewModel(comment: order.cancellationReason), fromOrderDetails: true)),
                  child: Text(
                    order.cancellationReason ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).primaryColor),
                  ),
                ),

              ]) : const SizedBox(),

              cancelled && order.cancellationNote != null && order.cancellationNote != '' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Text('${'cancellation_note'.tr}:', style: IBMPlexSansArabicMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialog(review: ReviewModel(comment: order.cancellationNote), fromOrderDetails: true)),
                  child: Text(
                    order.cancellationNote ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ),

              ]) : const SizedBox(),

              (order.orderStatus == 'refund_requested' || order.orderStatus == 'refund_request_canceled') ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                const Divider(height: Dimensions.paddingSizeLarge),
                order.orderStatus == 'refund_requested' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  RichText(text: TextSpan(children: [
                    TextSpan(text: '${'refund_note'.tr}:', style: IBMPlexSansArabicMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                    TextSpan(text: '(${(order.refund != null) ? order.refund!.customerReason : ''})', style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ])),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  (order.refund != null && order.refund!.customerNote != null) ? InkWell(
                    onTap: () => Get.dialog(ReviewDialog(review: ReviewModel(comment: order.refund!.customerNote), fromOrderDetails: true)),
                    child: Text(
                      '${order.refund!.customerNote}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: (order.refund != null && order.refund!.image != null) ? Dimensions.paddingSizeSmall : 0),

                  (order.refund != null && order.refund!.image != null && order.refund!.image!.isNotEmpty) ? InkWell(
                    onTap: () => showDialog(context: context, builder: (context) {
                      return ImageDialog(imageUrl: '${Get.find<SplashController>().configModel!.baseUrls!.refundImageUrl}/${order.refund!.image!.isNotEmpty ? order.refund!.image![0] : ''}');
                    }),
                    child: CustomImage(
                      height: 40, width: 40, fit: BoxFit.cover,
                      image: order.refund != null ? '${Get.find<SplashController>().configModel!.baseUrls!.refundImageUrl}/${order.refund!.image!.isNotEmpty ? order.refund!.image![0] : ''}' : '',
                    ),
                  ) : const SizedBox(),
                ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Divider(height: Dimensions.paddingSizeLarge),

                  Text('${'refund_cancellation_note'.tr}:', style: IBMPlexSansArabicMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: () => Get.dialog(ReviewDialog(review: ReviewModel(comment: order.refund!.adminNote), fromOrderDetails: true)),
                    child: Text(
                      '${order.refund != null ? order.refund!.adminNote : ''}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: IBMPlexSansArabicRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ),

                ]),
              ]) : const SizedBox(),

              (order.orderNote  != null && order.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Text('additional_note'.tr, style: IBMPlexSansArabicRegular),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: Dimensions.webMaxWidth,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                  ),
                  child: Text(
                    order.orderNote!,
                    style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]) : const SizedBox(),

              (order.orderStatus == 'delivered' && order.orderProof != null && order.orderProof!.isNotEmpty) ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
                ),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('order_proof'.tr, style: IBMPlexSansArabicRegular),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.5,
                      crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.orderProof!.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => openDialog(context, '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderProof![index]}'),
                          child: Center(child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImage(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderProof![index]}',
                              width: 100, height: 100,
                            ),
                          )),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ) : const SizedBox(),
            ]),
          ),
        ]),
      ),


      !ResponsiveHelper.isDesktop(context) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Text('item_info'.tr, style: IBMPlexSansArabicMedium),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderController.orderDetails!.length,
          itemBuilder: (context, index) {
            return OrderProductWidget(order: order, orderDetails: orderController.orderDetails![index]);
          },
        ),
      ]) : const SizedBox(),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('delivery_details'.tr, style: IBMPlexSansArabicMedium),
      ) : const SizedBox(),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          !isDesktop ? Text('delivery_details'.tr, style: IBMPlexSansArabicMedium) : const SizedBox(),
          SizedBox(height: isDesktop ? 0 : Dimensions.paddingSizeSmall),

          DeliveryDetails(from: true, address: order.restaurant?.address ?? ''),
          const Divider(height: Dimensions.paddingSizeLarge),

          DeliveryDetails(from: false, address: order.deliveryAddress?.address ?? ''),
        ]),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('restaurant_details'.tr, style: IBMPlexSansArabicMedium),
      ) : const SizedBox(),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          !isDesktop ? Text('restaurant_details'.tr, style: IBMPlexSansArabicMedium) : const SizedBox(),
          SizedBox(height: !isDesktop ? Dimensions.paddingSizeSmall : 0),

          order.restaurant != null ? Row(children: [
            ClipOval(child: CustomImage(
              image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${order.restaurant!.logo}',
              height: 35, width: 35, fit: BoxFit.cover,
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                order.restaurant!.name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              Text(
                order.restaurant!.address!, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
            ])),

            (takeAway && (pending || accepted || confirmed || processing || order.orderStatus == 'handover'
            || pickedUp)) ? TextButton.icon(
              onPressed: () async {
                String url ='https://www.google.com/maps/dir/?api=1&destination=${order.restaurant!.latitude}'
                    ',${order.restaurant!.longitude}&mode=d';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url, mode: LaunchMode.externalApplication);
                }else {
                  showCustomSnackBar('unable_to_launch_google_map'.tr);
                }
              },
              icon: const Icon(Icons.directions), label: Text('direction'.tr),
            ) : const SizedBox(),

            (showChatPermission && !delivered && order.orderStatus != 'failed' && !cancelled && order.orderStatus != 'refunded') ? InkWell(
              onTap: () async {
                orderController.cancelTimer();
                await Get.toNamed(RouteHelper.getChatRoute(
                  notificationBody: NotificationBody(orderId: order.id, restaurantId: order.restaurant!.vendorId),
                  user: User(id: order.restaurant!.vendorId, fName: order.restaurant!.name, lName: '', image: order.restaurant!.logo),
                ));
                orderController.callTrackOrderApi(orderModel: order, orderId: order.id.toString());
              },
              child: Image.asset(Images.chatImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
            ) : const SizedBox(),

            (!subscription && Get.find<SplashController>().configModel!.refundStatus! && delivered && orderController.orderDetails![0].itemCampaignId == null)
            ? InkWell(
              onTap: () => Get.toNamed(RouteHelper.getRefundRequestRoute(order.id.toString())),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeSmall),
                child: Text('request_for_refund'.tr, style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
              ),
            ) : const SizedBox(),

          ]) : Center(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Text(
              'no_restaurant_data_found'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
          )),
        ]),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      order.deliveryMan != null ? Column(children: [

        isDesktop ? Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Text('delivery_man_details'.tr, style: IBMPlexSansArabicMedium),
        ) : const SizedBox(),

        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              !isDesktop ? Text('delivery_man_details'.tr, style: IBMPlexSansArabicMedium) : const SizedBox(),
              SizedBox(height: !isDesktop ? Dimensions.paddingSizeSmall : 0),

              Row(children: [
                ClipOval(child: CustomImage(
                  image: '${ Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${order.deliveryMan!.image}',
                  height: 35, width: 35, fit: BoxFit.cover,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeSmall)
                  ),
                  RatingBar(
                    rating: order.deliveryMan!.avgRating, size: 10,
                    ratingCount: order.deliveryMan!.ratingCount,
                  ),
                ])),

                InkWell(
                  onTap: () async {
                    orderController.cancelTimer();
                    await Get.toNamed(RouteHelper.getChatRoute(
                      notificationBody: NotificationBody(deliverymanId: order.deliveryMan!.id, orderId: int.parse(order.id.toString())),
                      user: User(id: order.deliveryMan!.id, fName: order.deliveryMan!.fName, lName: order.deliveryMan!.lName, image: order.deliveryMan!.image),
                    ));
                    orderController.callTrackOrderApi(orderModel: order, orderId: order.id.toString());
                  },
                  child: Image.asset(Images.chatImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                InkWell(
                  onTap: () async {
                    if(await canLaunchUrlString('tel:${order.deliveryMan!.phone}')) {
                      launchUrlString('tel:${order.deliveryMan!.phone}', mode: LaunchMode.externalApplication);
                    }else {
                      showCustomSnackBar('${'can_not_launch'.tr} ${order.deliveryMan!.phone}');
                    }

                  },
                  child: Image.asset(Images.callImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
                ),

              ]),
            ]),
          ),
      ]) : const SizedBox(),
      SizedBox(height: order.deliveryMan != null ? Dimensions.paddingSizeLarge : 0),

      isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('payment_method'.tr, style: IBMPlexSansArabicMedium),
      ) : const SizedBox(),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          !isDesktop ? Text('payment_method'.tr, style: IBMPlexSansArabicMedium) : const SizedBox(),
          SizedBox(height: !isDesktop ? Dimensions.paddingSizeSmall : 0),

          Row(children: [

            Image.asset(
              order.paymentMethod == 'cash_on_delivery' ? Images.cashOnDelivery
                  : order.paymentMethod == 'wallet' ? Images.wallet
                  : order.paymentMethod == 'partial_payment' ? Images.partialWallet
                  : Images.digitalPayment,
              width: 20, height: 20,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Text(
                order.paymentMethod == 'cash_on_delivery' ? 'cash'.tr
                    : order.paymentMethod == 'wallet' ? 'wallet'.tr
                    : order.paymentMethod == 'partial_payment' ? 'partial_payment'.tr
                    : 'digital'.tr,
                style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
            ),

          ]),
        ]),
      ),
    ]);
  }
}

void openDialog(BuildContext context, String imageUrl) => showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Stack(children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          child: PhotoView(
            tightMode: true,
            imageProvider: NetworkImage(imageUrl),
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
          ),
        ),

        Positioned(top: 0, right: 0, child: IconButton(
          splashRadius: 5,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.cancel, color: Colors.red),
        )),

      ]),
    );
  },
);