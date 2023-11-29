import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../models/api_models/categories/category.dart';

class CategoryDisplay extends StatefulWidget {
  const CategoryDisplay({super.key});

  @override
  State<CategoryDisplay> createState() => _CategoryDisplayState();
}

class _CategoryDisplayState extends State<CategoryDisplay> {
  @override
  void initState() {
    context.read<MainBloc>()
      ..add(CategoryLoadingEvent())
      ..add(ProductForACategoryLoadingEvent(categoryId: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories = [];
    int clickedCategory = 1;
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      listenWhen: (prev, cur) {
        if (cur is UiActionState) {
          return true;
        } else {
          return false;
        }
      },
      buildWhen: (prev, cur) {
        if (cur.runtimeType == CategoryLoadingSuccessState ||
            cur.runtimeType == CategoryClickedState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state.runtimeType == CategoryLoadingSuccessState) {
          categories = (state as CategoryLoadingSuccessState).categories;
        }
        if (state.runtimeType == CategoryClickedState) {
          clickedCategory = (state as CategoryClickedState).categoryId;
        }
        return LayoutBuilder(builder: (context, constraints) {
          final screenWidth = constraints.widthConstraints().maxWidth;
          //print(screenWidth);
          return Card(
            elevation: 10,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return RotatedBox(
                  quarterTurns: (screenWidth >= 120) ? 0 : 3,
                  child: screenWidth < 80
                      ? TextButton(
                          style: TextButton.styleFrom(
                              // backgroundColor: Colors.grey.shade100
                              foregroundColor: (clickedCategory ==
                                      categories[index].categoryId)
                                  ? Colors.grey.shade700
                                  : Colors.cyan),
                          onPressed: () {
                            context.read<MainBloc>().add(
                                ProductForACategoryLoadingEvent(
                                    categoryId: categories[index].categoryId));
                          },
                          child: Text(
                            categories[index].categoryName,
                            style: TextStyle(
                                fontSize: screenWidth >= 80 ? 16 : 14),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  // backgroundColor: Colors.grey.shade100
                                  foregroundColor: (clickedCategory ==
                                          categories[index].categoryId)
                                      ? Colors.grey.shade700
                                      : Colors.cyan),
                              onPressed: () {
                                context.read<MainBloc>().add(
                                    ProductForACategoryLoadingEvent(
                                        categoryId:
                                            categories[index].categoryId));
                              },
                              child: Text(
                                categories[index].categoryName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth >= 80 ? 16 : 14,
                                ),
                              ),
                            ),
                            if (index == categories.length - 1 &&
                                screenWidth >= 120)
                              const Divider(
                                color: Colors.brown,
                              )
                          ],
                        ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.brown,
                );
              },
              itemCount: categories.length,
            ),
          );
        });
      },
    );
  }
}
