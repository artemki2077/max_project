import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:max_project/glob.dart' as glob;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';



class Basket extends StatefulWidget {
  const Basket({super.key});

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  List<dynamic> basket = [];
  late bool loading = false;
  var warninTitle = 'No data in basket';
  double totalSum = 0.0;

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> getBusket() async {
    totalSum = 0;
    var url = Uri.http(glob.host, 'basket');
    var response = await http.get(url);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse['ok']) {
      basket = decodedResponse['result'];
      basket.forEach((element) {
        totalSum += element['price'];
      });
    } else {
      warninTitle = decodedResponse['answer'];
    }
    setState(() {});
  }

  @override
  void initState() {
    getBusket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(
              color: glob.primColor,
            ),
          )
        : RefreshIndicator(
            onRefresh: () => getBusket(),
            child: basket.isEmpty
                ? ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(50),
                        child: Center(
                          child: Text(warninTitle),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (6.9 / 10),
                          child: ListView.builder(
                            itemCount: basket.length,
                            itemBuilder: (BuildContext context, int index) {
                              String imgLink =
                                  basket[index]['img_link'].toString();
                              String name = basket[index]['name'].toString();
                              String link = basket[index]['link'].toString();
                              var price = basket[index]['price'];
                              String prodType =
                                  glob.types[basket[index]['type'].toString()]!;
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _launchUrl(Uri.parse(link));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            glob.dark),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        // Change your radius here
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        // height: 150,
                                        width: 120,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image.network(
                                      
                                              imgLink,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 230,
                                              child: Text(
                                                name,
                                                softWrap: true,
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              )),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "Цена: ${glob.form.format(price)} руб"),
                                          Text("типо: ${prodType}"),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: '    Итог: ',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${glob.form.format(totalSum)} руб',
                                  style:
                                      const TextStyle(fontWeight: FontWeight.w300, fontSize: 25)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
  }
}
