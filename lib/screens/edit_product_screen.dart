// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/Editproduct';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _imageFocusNode = FocusNode();
  var _isinit = true;
  var _isLoading = false;
  final _imageEdittingController = TextEditingController();
  Product _editedProduct =
      Product(description: '', id: '', imageUrl: '', price: 0, title: '');
  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    // _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_updateImageUrl);
  }

  var _initValue = {
    'title': '',
    'description': ' ',
    'price': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isinit) {
      final Object? productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': ' ',
          //'imageUrl':''
        };
        _imageEdittingController.text = _editedProduct.imageUrl;
      }
      //if i was using text controller
      //_imageUrlCOntroller = _editedProduct.image
    }
    _isinit = false;
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageEdittingController.text.startsWith('http') &&
              !_imageEdittingController.text.startsWith('https')) ||
          (!_imageEdittingController.text.contains('.png') &&
              !_imageEdittingController.text.contains('.jpg') &&
              !_imageEdittingController.text.contains('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .update(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(
          context,
          listen: false,
        ).addProvider(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Error occured'),
                content: const Text('Something went wrong '),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Okey'))
                ],
              );
            });
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product'), actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveForm,
        ),
      ]),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: value!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provider a value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value!),
                            title: _editedProduct.title);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'enter a valid price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'enter a number greater than zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      //textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editedProduct = Product(
                            description: value!,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: _editedProduct.title);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description ';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageEdittingController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                      _imageEdittingController.text),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValue['imageUrl'],
                            decoration:
                                const InputDecoration(labelText: 'ImageUrl'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageEdittingController,
                            focusNode: _imageFocusNode,
                            onSaved: (value) {
                              _editedProduct = Product(
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  imageUrl: value!,
                                  price: _editedProduct.price,
                                  title: _editedProduct.title);
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a image link';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.contains('.png') &&
                                  !value.contains('.jpg') &&
                                  !value.contains('.jpeg')) {
                                return 'Please enter a valid image url';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ])),
            ),
    );
  }
}




  // void _saveForm() {
  //   final isValid = _form.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   _form.currentState!.save();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if (_editedProduct.id != null) {
  //     Provider.of<Products>(context, listen: false)
  //         .update(_editedProduct.id, _editedProduct);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     Navigator.of(context).pop();
  //   } else {
  //     Provider.of<Products>(
  //       context,
  //       listen: false,
  //     ).addProvider(_editedProduct).catchError((error) {
  //     return  showDialog(
  //           context: context,
  //           builder: (ctx) {
  //             return AlertDialog(
  //               title: const Text('Error occured'),
  //               content: const Text('Something went wrong '),
  //               actions: [
  //                 TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text('Okey'))
  //               ],
  //             );
  //           });
  //     }).then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       Navigator.of(context).pop();
  //     });
  //   }
  // }