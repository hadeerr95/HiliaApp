import 'package:app/app_properties.dart';
import 'package:app/bloc/catalog/catalog_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NotificationsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "notifications".tr(),
          style: TextStyle(
            color: darkGrey,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.grey[700]),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: <Widget>[
            // StreamBuilder<Object>(
            //   stream: null,
            //   builder: (context, snapshot) {
            BlocBuilder<CatalogCubit, CatalogState>(builder: (contaxt, state) {
              if (state.notifications.status == LoaderStatus.loaded) {
                return Flexible(
                  child: ListView(
                    children: state.notifications.data
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/background.jpg',
                                      ),
                                      maxRadius: 24,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: "${e.title} ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                TextSpan(
                                                  text: e.body,
                                                ),
                                                // TextSpan(
                                                //   text: '\$45.25',
                                                //   style: TextStyle(
                                                //     fontWeight:
                                                //         FontWeight.bold,
                                                //   ),
                                                // )
                                              ]),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //     Row(
                                    //       children: <Widget>[
                                    //         Icon(
                                    //           Icons.check_circle,
                                    //           size: 14,
                                    //           color: Colors.blue[700],
                                    //         ),
                                    //         Padding(
                                    //           padding: const EdgeInsets.symmetric(
                                    //               horizontal: 8.0),
                                    //           child: AutoSizeText('Pay',
                                    //               style: TextStyle(
                                    //                   color: Colors.blue[700])),
                                    //         )
                                    //       ],
                                    //     ),
                                    InkWell(
                                      onTap: () => context
                                          .bloc<CatalogCubit>()
                                          .removeNotification(e),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.cancel,
                                            size: 14,
                                            color: Color(0xffF94D4D),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: AutoSizeText('Delete',
                                                style: TextStyle(
                                                    color: Color(0xffF94D4D))),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    // children: <Widget>[
                    //   // Request amount
                    //   Container(
                    //     padding: const EdgeInsets.all(16.0),
                    //     margin: const EdgeInsets.symmetric(vertical: 4.0),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    //     child: Column(
                    //       children: <Widget>[
                    //         Row(
                    //           children: <Widget>[
                    //             CircleAvatar(
                    //               backgroundImage: AssetImage(
                    //                 'assets/background.jpg',
                    //               ),
                    //               maxRadius: 24,
                    //             ),
                    //             Flexible(
                    //               child: Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 16.0),
                    //                 child: RichAutoSizeText(
                    //                   text: TextSpan(
                    //                       style: TextStyle(
                    //                         fontFamily: 'Montserrat',
                    //                         color: Colors.black,
                    //                       ),
                    //                       children: [
                    //                         TextSpan(
                    //                             text: 'Sai Sankar Ram',
                    //                             style: TextStyle(
                    //                               fontWeight: FontWeight.bold,
                    //                             )),
                    //                         TextSpan(
                    //                           text: ' Requested for ',
                    //                         ),
                    //                         TextSpan(
                    //                           text: '\$45.25',
                    //                           style: TextStyle(
                    //                             fontWeight: FontWeight.bold,
                    //                           ),
                    //                         )
                    //                       ]),
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: <Widget>[
                    //             Row(
                    //               children: <Widget>[
                    //                 Icon(
                    //                   Icons.check_circle,
                    //                   size: 14,
                    //                   color: Colors.blue[700],
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 8.0),
                    //                   child: AutoSizeText('Pay',
                    //                       style:
                    //                           TextStyle(color: Colors.blue[700])),
                    //                 )
                    //               ],
                    //             ),
                    //             Row(
                    //               children: <Widget>[
                    //                 Icon(
                    //                   Icons.cancel,
                    //                   size: 14,
                    //                   color: Color(0xffF94D4D),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 8.0),
                    //                   child: AutoSizeText('Decline',
                    //                       style: TextStyle(
                    //                           color: Color(0xffF94D4D))),
                    //                 )
                    //               ],
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    //   // Send amount
                    //   Container(
                    //     margin: const EdgeInsets.symmetric(vertical: 4.0),
                    //     padding: const EdgeInsets.all(16.0),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    //     child: Column(
                    //       children: <Widget>[
                    //         Row(
                    //           children: <Widget>[
                    //             CircleAvatar(
                    //               backgroundImage: AssetImage(
                    //                 'assets/background.jpg',
                    //               ),
                    //               maxRadius: 24,
                    //             ),
                    //             Flexible(
                    //               child: Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 16.0),
                    //                 child: RichAutoSizeText(
                    //                   text: TextSpan(
                    //                       style: TextStyle(
                    //                         fontFamily: 'Montserrat',
                    //                         color: Colors.black,
                    //                       ),
                    //                       children: [
                    //                         TextSpan(
                    //                             text: 'Sai Sankar Ram',
                    //                             style: TextStyle(
                    //                               fontWeight: FontWeight.bold,
                    //                             )),
                    //                         TextSpan(
                    //                           text: ' Send You ',
                    //                         ),
                    //                         TextSpan(
                    //                           text: '\$45.25',
                    //                           style: TextStyle(
                    //                             fontWeight: FontWeight.bold,
                    //                           ),
                    //                         )
                    //                       ]),
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: <Widget>[
                    //             Row(
                    //               children: <Widget>[
                    //                 Icon(
                    //                   Icons.check_circle,
                    //                   size: 14,
                    //                   color: Colors.blue[700],
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 8.0),
                    //                   child: AutoSizeText('Accept',
                    //                       style:
                    //                           TextStyle(color: Colors.blue[700])),
                    //                 )
                    //               ],
                    //             ),
                    //             Row(
                    //               children: <Widget>[
                    //                 Icon(
                    //                   Icons.cancel,
                    //                   size: 14,
                    //                   color: Color(0xffF94D4D),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 8.0),
                    //                   child: AutoSizeText('Decline',
                    //                       style: TextStyle(
                    //                           color: Color(0xffF94D4D))),
                    //                 )
                    //               ],
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    //   // Share your feedback.
                    //   Container(
                    //     margin: const EdgeInsets.symmetric(vertical: 4.0),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.stretch,
                    //       children: <Widget>[
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Row(children: [
                    //             SizedBox(
                    //               height: 110,
                    //               width: 110,
                    //               child: Stack(children: <Widget>[
                    //                 Positioned(
                    //                   left: 5.0,
                    //                   bottom: -10.0,
                    //                   child: SizedBox(
                    //                     height: 100,
                    //                     width: 100,
                    //                     child: Transform.scale(
                    //                       scale: 1.2,
                    //                       child: Image.asset(
                    //                           'assets/bottom_yellow.png'),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Positioned(
                    //                   top: 8.0,
                    //                   left: 10.0,
                    //                   child: SizedBox(
                    //                       height: 80,
                    //                       width: 80,
                    //                       child: Image.asset(
                    //                           'assets/firstScreen.png')),
                    //                 )
                    //               ]),
                    //             ),
                    //             Flexible(
                    //               child: Column(children: [
                    //                 AutoSizeText(
                    //                     'Boat Rockerz 350 On-Ear Bluetooth firstScreen',
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 10)),
                    //                 SizedBox(height: 4.0),
                    //                 AutoSizeText(
                    //                     'Your package has been delivered. Thanks for shopping!',
                    //                     style: TextStyle(
                    //                         color: Colors.grey, fontSize: 10))
                    //               ]),
                    //             )
                    //           ]),
                    //         ),
                    //         InkWell(
                    //           onTap: () =>
                    //               Navigator.of(context).push(MaterialPageRoute(
                    //                   builder: (_) => RatingPage(
                    //                         product: null,
                    //                       ))),
                    //           child: Container(
                    //               padding: const EdgeInsets.all(14.0),
                    //               decoration: BoxDecoration(
                    //                   color: yellow,
                    //                   borderRadius: BorderRadius.only(
                    //                       bottomRight: Radius.circular(5.0),
                    //                       bottomLeft: Radius.circular(5.0))),
                    //               child: Align(
                    //                   alignment: Alignment.centerRight,
                    //                   child: AutoSizeText(
                    //                     'Share your feedback',
                    //                     style: TextStyle(
                    //                         color: Colors.white,
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 10),
                    //                   ))),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    //   // Track the product.
                    //   Container(
                    //     margin: const EdgeInsets.symmetric(vertical: 4.0),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.stretch,
                    //       children: <Widget>[
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Row(children: [
                    //             SizedBox(
                    //               height: 110,
                    //               width: 110,
                    //               child: Stack(children: <Widget>[
                    //                 Positioned(
                    //                   left: 5.0,
                    //                   bottom: -10.0,
                    //                   child: SizedBox(
                    //                     height: 100,
                    //                     width: 100,
                    //                     child: Transform.scale(
                    //                       scale: 1.2,
                    //                       child: Image.asset(
                    //                           'assets/bottom_yellow.png'),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Positioned(
                    //                   top: 8.0,
                    //                   left: 10.0,
                    //                   child: SizedBox(
                    //                       height: 80,
                    //                       width: 80,
                    //                       child: Image.asset(
                    //                           'assets/firstScreen.png')),
                    //                 )
                    //               ]),
                    //             ),
                    //             Flexible(
                    //               child: Column(children: [
                    //                 AutoSizeText(
                    //                     'Boat Rockerz 440 On-Ear Bluetooth firstScreen',
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 10)),
                    //                 SizedBox(height: 4.0),
                    //                 AutoSizeText(
                    //                     'Your package has been dispatched. You can keep track of your product.',
                    //                     style: TextStyle(
                    //                         color: Colors.grey, fontSize: 10))
                    //               ]),
                    //             )
                    //           ]),
                    //         ),
                    //         InkWell(
                    //           onTap: () => Navigator.of(context).push(
                    //               MaterialPageRoute(
                    //                   builder: (_) => TrackingPage())),
                    //           child: Container(
                    //               padding: const EdgeInsets.all(14.0),
                    //               decoration: BoxDecoration(
                    //                   color: yellow,
                    //                   borderRadius: BorderRadius.only(
                    //                       bottomRight: Radius.circular(5.0),
                    //                       bottomLeft: Radius.circular(5.0))),
                    //               child: Align(
                    //                   alignment: Alignment.centerRight,
                    //                   child: AutoSizeText(
                    //                     'Track the product',
                    //                     style: TextStyle(
                    //                         color: Colors.white,
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 10),
                    //                   ))),
                    //         )
                    //       ],
                    //     ),
                    //   )
                    // ],
                  ),
                );
              } else {
                return SizedBox();
              }
            })
          ])),
    );
  }
}
