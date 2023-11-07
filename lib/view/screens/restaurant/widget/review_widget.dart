import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/review_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  const ReviewWidget({Key? key, required this.review, required this.hasDivider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.dialog(ReviewDialog(review: review)),
      child: Column
        (children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ClipOval(
            child: CustomImage(
              image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${review.foodImage ?? ''}',
              height: 50, width: 50, fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              review.foodName!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: IBMPlexSansArabicBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
            ),

            RatingBar(rating: review.rating!.toDouble(), ratingCount: null, size: 15),

            Text(
              review.customerName ?? '',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
            ),

            Text(
              review.comment!, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: IBMPlexSansArabicRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
            ),
            //const SizedBox(height: Dimensions.paddingSizeLarge),

          ])),

        ]),

        //(hasDivider && ResponsiveHelper.isMobile(context)) ? Padding(
          //padding: const EdgeInsets.only(left: 70),
         // child: Divider(color: Theme.of(context).disabledColor),
       // ) : const SizedBox(height:1),

      ]),
    );
  }
}
