import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_all_discount_prod_controller.dart';
import 'package:temi_special_flutter/controllers/database/retrieve_all_product_controller.dart';
import 'package:temi_special_flutter/favourite/favourite.dart';
import 'package:temi_special_flutter/utils/colors.dart';
import 'package:temi_special_flutter/utils/constants.dart';
import 'package:temi_special_flutter/utils/dimensions.dart';
import 'package:temi_special_flutter/views/cards/home_page_cards/discount_product_card.dart';
import 'package:temi_special_flutter/views/cards/home_page_cards/product_card.dart';
import 'package:http/http.dart' as http;
import 'package:temi_special_flutter/views/cards/home_page_cards/search_card.dart';
import 'package:temi_special_flutter/widgets/custom_app_bar.dart';
import 'package:temi_special_flutter/widgets/custom_loader.dart';
import 'package:temi_special_flutter/widgets/custom_snackbar.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  RetrieveAllProductController retrieveAllProductController = Get.put(RetrieveAllProductController());
  List categories = Get.find<RetrieveAllProductController>().cat;
  List discountList = Get.find<RetrieveAllDiscountProdController>().allProd;
  int selectedIndex = 0;
  List products = [];
  List discountProducts = [];
  List image = [];
  List discountImage = [];
  List title = [];
  List discountTitle = [];
  List discountSubtitle = [];
  List prepTime = [];
  List discountPrepTime = [];
  List rating = [];
  List discountRating = [];
  List price = [];
  List discountPrice = [];
  List desc = [];
  List discountDesc = [];
  List discount = [];
  bool isLoading = true;

  Future<void> initController()async{
    RetrieveAllProductController().retrieveData();
    RetrieveAllDiscountProdController().retrieveData();
  }

  void retrieveData(category) async{
    setState(() {
      isLoading = true;
    });
    var reqBody = {
      "category": category,
    };
    try {
      http.Response response = await http.post(Uri.parse(retrieveCategoryProductUrl),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(reqBody),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse['status']){
          var i = 0;
          List prod = jsonResponse['message'];
          for (i;i<prod.length;i++){
            products.add(prod[i]);
            setState(() {
              image.add(products[i]["image"]);
              title.add(products[i]["title"]);
              prepTime.add(products[i]["prep_time"]);
              rating.add(products[i]["rating"]);
              price.add(products[i]["price"]);
              desc.add(products[i]["desc"]);
            });
          }
        }
      } else {
        debugPrint("Error fetching data");
      }
    } catch (e) {
      debugPrint("Error $e getting while fetching data");
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  void retrieveDiscountData(){
    var i = 0;
    List prod = discountList;
    for (i;i<prod.length;i++){
      discountProducts.add(prod[i]);
      setState(() {
        discountImage.add(discountProducts[i]["image"]);
        discountTitle.add(discountProducts[i]["title"]);
        discountSubtitle.add(discountProducts[i]["sub_title"]);
        discountPrepTime.add(discountProducts[i]["prep_time"]);
        discountRating.add(discountProducts[i]["rating"]);
        discountPrice.add(discountProducts[i]["price"]);
        discountDesc.add(discountProducts[i]["desc"]);
        discount.add(discountProducts[i]["discount"]);
      });
    }
  }

  void searchProduct(){
    showSearch(
        context: context,
        delegate: DataSearch()
    );
  }


  @override
  void initState() {
    super.initState();
    initController().then((value) {
      Future.delayed(const Duration(seconds: 1),(){retrieveData(categories[0]);retrieveDiscountData();});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(()=>retrieveAllProductController.isLoading.value?const Center(child: CustomLoader()):Scaffold(
      appBar: const CustomAppBar(title: "Home"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: Dimensions.screenHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchCard(onTap:(){searchProduct();}),
              SizedBox(
                width: double.maxFinite,
                height: Dimensions.height56,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories.toSet().length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedIndex = index;
                            products.clear();
                            image.clear();
                            title.clear();
                            prepTime.clear();
                            rating.clear();
                            price.clear();
                            retrieveData(categories[index]);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.width8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: selectedIndex==index?AppColors.mainColor:null,
                                borderRadius: BorderRadius.circular(Dimensions.radius15)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.width8),
                              child: Center(child: Text(categories[index],
                                style: TextStyle(color: selectedIndex==index?Colors.white:Colors.black,
                                    fontSize: Dimensions.font16
                                ),)),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: Dimensions.height10*24,
                width: double.maxFinite,
                child: isLoading?const Center(child: CustomLoader()):ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index){
                      return ProductCard(
                        onTap:(){
                          Get.toNamed('/item-page', arguments: [
                            image[index],
                            title[index],
                            prepTime[index],
                            rating[index],
                            price[index],
                            desc[index]
                          ]);
                        },
                        image: image[index],
                        title: title[index],
                        prepTime: prepTime[index],
                        rating: rating[index],
                        price: price[index],
                        onFav: (){
                          setState(() {
                            boxFavourites.put(
                                "key_${title[index]}",
                                Favourite(
                                    image: image[index],
                                    title: title[index],
                                )
                            );
                          });
                          showCustomSnackBar("Favourite added successfully");
                        },
                      );
                }),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimensions.height20, left: Dimensions.width10, right: Dimensions.width10, bottom: Dimensions.height20),
                child: Text("Discount Offers",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.font20,
                  ),),
              ),
              Flexible(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: discountProducts.length,
                    itemBuilder: (context, index){
                      return DiscountProductCard(
                        onTap:(){
                          Get.toNamed('/item-page', arguments: [
                            discountImage[index],
                            discountTitle[index],
                            discountPrepTime[index],
                            discountRating[index],
                            discountPrice[index],
                            discountDesc[index]
                          ]);
                        },
                        image: discountImage[index],
                        title: discountTitle[index],
                        subTitle: discountSubtitle[index],
                        prepTime: discountPrepTime[index],
                        rating: discountRating[index],
                        price: discountPrice[index],
                        discount: discount[index],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class DataSearch extends SearchDelegate {
  DataSearch({
    String hintText = "Search",
  }) : super(
    searchFieldLabel: hintText,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
    searchFieldStyle: const TextStyle(
      color: Colors.black,
    ),
  );
  // Demo list to show querying
  List searchTerms = [];

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    searchTerms.clear();
    searchTerms.addAll(Get.find<RetrieveAllProductController>().item);
    searchTerms.addAll(Get.find<RetrieveAllDiscountProdController>().item);
    List<String> matchQuery = [];
    for (var product in searchTerms) {
      if (product.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return GestureDetector(
          onTap: (){
            Get.toNamed('/search-item-page', arguments: result);
          },
          child: ListTile(
            title: Text(result),
          ),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    searchTerms.clear();
    searchTerms.addAll(Get.find<RetrieveAllProductController>().item);
    searchTerms.addAll(Get.find<RetrieveAllDiscountProdController>().item);
    List<String> matchQuery = [];
    for (var product in searchTerms) {
      if (product.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return GestureDetector(
          onTap: (){
            Get.toNamed('/search-item-page', arguments: result);
          },
          child: ListTile(
            title: Text(result),
          ),
        );
      },
    );
  }
}