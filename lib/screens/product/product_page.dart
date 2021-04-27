import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:app/screens/components/hilia_scaffold.dart';
import 'package:app/screens/home/components/product_grid_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatefulWidget {
  final int id;

  ProductPage({Key key, this.id}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState(id);
}

class _ProductPageState extends State<ProductPage> {
  final int categId;

  _ProductPageState(this.categId);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
      return Scaffold(
        appBar: HiliaAppBar(
          title: AutoSizeText(
            "",
            // state.getCategory(categId).name ?? "",
            style: TextStyle(color: Colors.grey[700]),
          ),
          // bottom: PreferredSize(
          //     child: Column(
          //       children: [
          //         ButtonBar(
          //           alignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             IconButton(icon: Icon(Icons.sort), onPressed: null),
          //             IconButton(icon: Icon(Icons.sort), onPressed: null),
          //             IconButton(icon: Icon(Icons.sort), onPressed: null),
          //           ],
          //         ),
          //         // Container(
          //         //   color: Colors.grey,
          //         //   height: 4.0,
          //         // ),
          //       ],
          //     ),
          //     preferredSize: Size.fromHeight(kToolbarHeight)),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              ProductGridView(
                products: null, //state.getProductsByCategoryId(categId),
              ),
            ],
            // children: state.getProductsByCategoryId(categId).map((e) => null),
          ),
        ),
      );
    });
  }
}
