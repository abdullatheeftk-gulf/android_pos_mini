import 'dart:io';

import 'package:android_pos_mini/general_functions/triple.dart';
import 'package:android_pos_mini/models/api_models/categories/category.dart';
import 'package:android_pos_mini/models/api_models/product/product.dart';
import 'package:android_pos_mini/presentation/working_screens/common_screens/check_box_for_categories/check_box_for_categories_display.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../blocs/main/main_bloc.dart';
import '../../../../../../general_functions/general_functions.dart';
import '../../../../../../general_functions/pair.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _productNameController = TextEditingController();
  final _productLocalNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productTaxInPercentage = TextEditingController(text: '0');
  final _infoController = TextEditingController();

  int selectedRadio = 0;

  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedFile;
  bool isImageLoading = false;
  File? fileToDisplay;

  List<Category> _listOfCategories = [];
  List<Pair<int, String>> _listOfSelectedCategories =
      List.empty(growable: true);

  @override
  void initState() {
    context.read<MainBloc>().add(CategoryLoadingEvent());
    _listOfSelectedCategories.add(Pair(first: -1, second: 'Add New'));
    super.initState();
  }

  void _pickFile() async {
    try {
      setState(() {
        isImageLoading = true;
      });
      result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);

      if (result != null) {
        fileName = result!.files.first.name;
        pickedFile = result!.files.first;
        fileToDisplay = File(pickedFile!.path.toString());
        // print('File name $fileName');
      } else {
        setState(() {});
      }

      setState(() {
        isImageLoading = false;
      });
    } catch (e) {
      // print(e);
    }
  }

  void _showBottomSheet(BuildContext context, List<Category> listOfCategories,
      List<Pair<int, String>> listOfSelectedCategory) {
    // print(listOfSelectedCategory.length);

    final List<Triple<int, Category, bool>> newTripleList =
        List.empty(growable: true);

    for (var category in listOfCategories) {
      bool isCategoryNotAdded = true;
      for (var pair in listOfSelectedCategory) {
        if (pair.first == category.categoryId) {
          newTripleList.add(Triple(
              first: category.categoryId, second: category, third: true));
          isCategoryNotAdded = false;
        }
      }
      if (isCategoryNotAdded) {
        newTripleList.add(
            Triple(first: category.categoryId, second: category, third: false));
      }
    }

    showBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        elevation: 6,
        builder: (context) {
          return SizedBox(
            height: 600,
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            CheckBoxForCategoriesDisplay(
                              callBack: (bool isCategoryClicked) {
                                final category = listOfCategories[index];
                                //print(category.categoryName);
                                context.read<MainBloc>().add(
                                    CategoriesSelectedForProductEvent(
                                        category: category,
                                        isCategoryChecked: isCategoryClicked));
                              },
                              isChecked: newTripleList[index].third,
                            ),
                            Text(listOfCategories[index].categoryName)
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: listOfCategories.length),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Save'))),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                // Todo
                              },
                              child: const Text('Add new Category')))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state.runtimeType == ShowSnackBarInAddProductScreenState) {
          final String message =
              (state as ShowSnackBarInAddProductScreenState).message;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
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
        bool showProgressBar = false;

        switch (state.runtimeType) {
          case ApiFetchingStartedState:
            {
              showProgressBar = true;
              break;
            }
          case NotShowProgressBarState:
            {
              showProgressBar = false;
              break;
            }
          case ApiFetchingFailedState:
            {
              showProgressBar = false;
              final errorMessage =
                  (state as ApiFetchingFailedState).errorString;
              context.read<MainBloc>().add(ShowSnackBarInAddProductScreenEvent(
                  message: errorMessage ?? 'There have some problem'));
              break;
            }
          case AddProductSuccessState:
            {
              result = null;
              fileName = null;
              fileToDisplay = null;
              pickedFile = null;
              isImageLoading = false;
              _productNameController.text = "";
              _productPriceController.text = "";
              _productTaxInPercentage.text = "";
              _productLocalNameController.text = "";
              _infoController.text = "";
              _listOfSelectedCategories
                  .removeWhere((element) => element.first != -1);

              showProgressBar = false;
              break;
            }
          case CategoryLoadingSuccessState:
            {
              showProgressBar = false;
              _listOfCategories =
                  (state as CategoryLoadingSuccessState).categories;
              break;
            }
          case CategorySelectedForProductState:
            {
              showProgressBar = false;
              _listOfSelectedCategories =
                  (state as CategorySelectedForProductState).listOfCategory;
              _listOfSelectedCategories =
                  _listOfSelectedCategories.reversed.toList();
              break;
            }
          case TransliterateTextState:
            {
              _productLocalNameController.text =
                  (state as TransliterateTextState).value;
              break;
            }

          case TranslateTextState:
            {
              _productLocalNameController.text =
                  (state as TranslateTextState).value;
              break;
            }
          default:
            {
              showProgressBar = false;
            }
        }

        return Scaffold(
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: _productNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter valid product name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Product Name'),
                            hintText: "Enter Product Name",
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.green,
                                  onChanged: (value) {
                                    context.read<MainBloc>().add(
                                        TranslateTextEvent(
                                            value:
                                                _productNameController.text));
                                    setState(() {
                                      selectedRadio = 1;
                                    });
                                  },
                                ),
                                const Text('Translate Text'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 2,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    context.read<MainBloc>().add(
                                        TransliterateTextEvent(
                                            value:
                                                _productNameController.text));
                                    setState(() {
                                      selectedRadio = 2;
                                    });
                                  },
                                ),
                                const Text('Transliterate Text'),
                              ],
                            )
                          ],
                        ),
                        TextFormField(
                          controller: _productLocalNameController,
                          decoration: const InputDecoration(
                            label: Text('Product Local Name'),
                            hintText: 'Enter Product Local Name',
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 150,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                  child: Text(
                                'Product Image :- ',
                                style: TextStyle(fontSize: 15),
                              )),
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        hideKeyboard(context);
                                        _pickFile();
                                      },
                                      child: Visibility(
                                        visible: pickedFile == null,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Pick Image'),
                                            Icon(Icons.add)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isImageLoading,
                                      child: const CircularProgressIndicator(),
                                    ),
                                    if (pickedFile != null)
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0.5)),
                                        child: Image.file(fileToDisplay!),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: _productPriceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Product price is empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Product Price'),
                            hintText: 'Enter Product Price',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextFormField(
                          controller: _productTaxInPercentage,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                              label: Text('Product Tax Percentage'),
                              hintText: 'Enter Product Tax'),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Text('Categories :- '),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              //flex: 1,
                              child: SizedBox(
                                height: 80,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (_listOfSelectedCategories[index]
                                            .first ==
                                        -1) {
                                      return InkWell(
                                        onTap: () {
                                          _showBottomSheet(
                                            context,
                                            _listOfCategories,
                                            _listOfSelectedCategories,
                                          );
                                        },
                                        child: Chip(
                                          label: const Text(
                                            'Add',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          deleteIcon: Transform(
                                              transform: Matrix4.identity()
                                                ..scale(0.8),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              )),
                                          onDeleted: () {
                                            hideKeyboard(context);
                                            _showBottomSheet(
                                              context,
                                              _listOfCategories,
                                              _listOfSelectedCategories,
                                            );
                                          },
                                          backgroundColor: Colors.amber,
                                          visualDensity: const VisualDensity(
                                              horizontal: -4, vertical: -4),
                                        ),
                                      );
                                    }
                                    return Chip(
                                      label: Text(
                                          _listOfSelectedCategories[index]
                                              .second),
                                      deleteIcon: Transform(
                                          transform: Matrix4.identity()
                                            ..scale(0.8),
                                          child: const Icon(Icons.clear)),
                                      deleteIconColor: Colors.red,
                                      visualDensity: const VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      onDeleted: () {
                                        context.read<MainBloc>().add(
                                            RemoveOneItemFromTheProductAddCategoryListEvent(
                                                categoryId:
                                                    _listOfSelectedCategories[
                                                            index]
                                                        .first));
                                      },
                                      backgroundColor: Colors.white,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      width: 2,
                                    );
                                  },
                                  itemCount: _listOfSelectedCategories.length,
                                ),
                              ),
                            )
                          ],
                        ),
                        TextField(
                          controller: _infoController,
                          decoration: const InputDecoration(
                            label: Text('info'),
                            hintText: 'Enter info',
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          onPressed: showProgressBar
                              ? null
                              : () {
                                  hideKeyboard(context);

                                  if (_listOfSelectedCategories.length <= 1) {
                                    print('_listOfSelectedCategories.isEmpty');
                                    context.read<MainBloc>().add(
                                        ShowSnackBarInAddProductScreenEvent(
                                            message:
                                                'Categories are not selected'));
                                  } else {
                                    if (_formKey.currentState!.validate()) {
                                      final List<int> categories =
                                          List.empty(growable: true);

                                      for (var element
                                          in _listOfSelectedCategories) {
                                        categories.add(element.first);
                                      }

                                      categories.removeWhere(
                                          (element) => element == -1);

                                      final product = Product(
                                          productId: 0,
                                          productName:
                                              _productNameController.text,
                                          productLocalName:
                                              _productLocalNameController.text,
                                          productPrice: double.parse(
                                              _productPriceController.text),
                                          productTaxInPercentage: double.parse(
                                              _productTaxInPercentage.text),
                                          productImage: null,
                                          info: _infoController.text,
                                          multiProducts: [],
                                          categories: categories);
                                      context.read<MainBloc>().add(
                                          AddAProductEvent(
                                              product: product,
                                              file: fileToDisplay));
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  showProgressBar
                      ? const CircularProgressIndicator()
                      : const SizedBox()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
