import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/footer_view.dart';
import 'package:efood_multivendor/view/base/menu_drawer.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<CategoryController>().getCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: 'categories'.tr),
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      body: SafeArea(child: Scrollbar(child: SingleChildScrollView(child: FooterView(
        child: Column(
          children: [
            WebScreenTitleWidget(title: 'categories'.tr),

            Center(child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: GetBuilder<CategoryController>(builder: (catController) {
                return catController.categoryList != null ? catController.categoryList!.isNotEmpty ? GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 3,
                    childAspectRatio: (1/1),
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemCount: catController.categoryList!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                        catController.categoryList![index].id, catController.categoryList![index].name!,
                      )),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                        ),
                        alignment: Alignment.center,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImage(
                              height: 50, width: 50, fit: BoxFit.cover,
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.categoryList![index].image}',
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text(
                            catController.categoryList![index].name!, textAlign: TextAlign.center,
                            style: IBMPlexSansArabicMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),

                        ]),
                      ),
                    );
                  },
                ) : NoDataScreen(title: 'no_category_found'.tr) : const Center(child: CircularProgressIndicator());
              }),
            )),
          ],
        ),
      )))),
    );
  }
}