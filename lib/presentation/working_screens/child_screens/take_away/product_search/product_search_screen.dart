import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/general_functions/general_functions.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/food_item_display/children/food_item_card_in_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/api_models/product/product.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    print('ProductSearchScreenState dispose');
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showProgressBar = false;

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if(state.runtimeType == ShowSnackBarInProductSearchScreenState){
          final message= (state as ShowSnackBarInProductSearchScreenState).message;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      listenWhen: (prev, cur) {
        if (cur is UiActionState) {
          return true;
        } else {
          return false;
        }
      },
      buildWhen: (prev, cur) {
        if (cur is UiBuildState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        List<Product> products = [];

        switch (state.runtimeType) {
          case ApiFetchingStartedState:
            {
              showProgressBar = true;
              break;
            }
          case ApiFetchingFailedState:
            {
              showProgressBar = false;
              break;
            }
          case SearchProductByKeySuccessState:
            {
              showProgressBar = false;
              products = (state as SearchProductByKeySuccessState).products;
              break;
            }
          default:
            {
              showProgressBar = false;
              break;
            }
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: _searchController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        label: const Text("Search"),
                        hintText: 'Search in here',
                        hintStyle: TextStyle(
                          color: Colors.black26.withOpacity(0.3),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if(_searchController.text.isEmpty){
                              context.read<MainBloc>().add(ShowSnackBarInProductSearchScreenEvent(message: 'Search With empty value'));
                              return;
                            }
                            hideKeyboard(context);
                            context.read<MainBloc>().add(
                                SearchForProductByKeyEvent(
                                    key: _searchController.text));
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        if(_searchController.text.isEmpty){
                          context.read<MainBloc>().add(ShowSnackBarInProductSearchScreenEvent(message: 'Search With empty value'));
                          return;
                        }
                        hideKeyboard(context);
                        context.read<MainBloc>().add(SearchForProductByKeyEvent(
                            key: _searchController.text));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return FoodItemCardInList(product: products[index], productAddedEvent: (Product product){
                            // Todo
                          },);
                        },
                        itemCount: products.length,
                      ),
                    )
                  ],
                ),
                showProgressBar
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
