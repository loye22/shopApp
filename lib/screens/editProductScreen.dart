import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:louie_shop/models/products.dart';
import 'package:louie_shop/provider/product_provider.dart';
import 'package:provider/provider.dart';

class editProductScreen extends StatefulWidget {
  static const routeName = '/editProductScreen';

  @override
  State<editProductScreen> createState() => _editProductScreenState();
}

class _editProductScreenState extends State<editProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editingProduct =
      Product(id: null, imageUrl: '', title: '', price: 0.0, description: '');
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose

    _descriptionFocus.dispose();
    _priceFocus.dispose();
    _imageUrlController.dispose();
    _imageUrlFocus.removeListener(_UpdateimageurlFocus);
    _imageUrlFocus.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocus.addListener(_UpdateimageurlFocus);
    super.initState();
  }

  void _UpdateimageurlFocus() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm()  async{
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (_editingProduct.id != null) {

      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      await Provider.of<product_provider>(context, listen: false)
          .editProduct(_editingProduct.id, _editingProduct)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }

    else {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try{
        await Provider.of<product_provider>(context, listen: false)
            .addProduct(_editingProduct);

      }
      catch(e){
         await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Somthing went wrong'),
                content: Text('error $e '),
                actions: [
                  FlatButton(
                      onPressed: () {

                        setState(() {
                          _isLoading=false;
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Text('ok'))
                ],
              );
            });
      }
      finally{
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }



    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    if (id != null) {
      print(id);
      _editingProduct =
          Provider.of<product_provider>(context, listen: false).findById(id);
      _initValues = {
        'title': _editingProduct.title,
        'description': _editingProduct.description,
        'price': _editingProduct.price.toString(),
        'imageUrl': '',
      };
      _imageUrlController.text = _editingProduct.imageUrl;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        label: Text('title'),
                        errorStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                            fontSize: 18),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (value) {
                        _editingProduct = Product(
                            id: _editingProduct.id,
                            description: _editingProduct.description,
                            price: _editingProduct.price,
                            title: value,
                            imageUrl: _editingProduct.imageUrl);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'plz fill this filed';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        label: Text('Price'),
                      ),
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'plz fill this filed';
                        }
                        if (double.tryParse(v) == null) {
                          return 'plz enter valid number';
                        }
                        if (double.parse(v) <= 0) {
                          return 'plz enter number above than 0';
                        }
                        return null;
                      },
                      focusNode: _priceFocus,
                      onSaved: (value) {
                        _editingProduct = Product(
                            id: _editingProduct.id,
                            description: _editingProduct.description,
                            price: double.parse(value),
                            title: _editingProduct.title,
                            imageUrl: _editingProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        label: Text('Description'),
                      ),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocus,
                      maxLines: 3,
                      onSaved: (value) {
                        _editingProduct = Product(
                            id: _editingProduct.id,
                            description: value,
                            price: _editingProduct.price,
                            title: _editingProduct.title,
                            imageUrl: _editingProduct.imageUrl);
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'plz fill this filed';
                        }
                        if (v.length < 10) {
                          return 'the decrition should be more than 10 letters';
                        }
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('enter url')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(label: Text('Enter image url')),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocus,
                            onFieldSubmitted: (_) {
                              setState(() {});
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editingProduct = Product(
                                  id: _editingProduct.id,
                                  description: _editingProduct.description,
                                  price: _editingProduct.price,
                                  title: _editingProduct.title,
                                  imageUrl: value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
