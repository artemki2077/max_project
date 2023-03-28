import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:max_project/glob.dart' as glob;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchTextController = TextEditingController();
  late List<dynamic> data = <dynamic>[];
  String prodType = 'None';
  String warninTitle = 'Тут пока пусто';
  // твёрданакопитель
  // видеокарта

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  reqAdd(data) async {
    var url = Uri.http(glob.host, 'add');
    var response = await http.post(url, body: json.encode({'prod': data}), headers: {'Content-Type': 'application/json; charset=UTF-8',},);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
  }

  reqSearch() async {
    var url = Uri.http(glob.host, 'search',
        {'text': searchTextController.text, 'type': prodType});
    var response = await http.get(url);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse['ok']) {
      data = decodedResponse['result'];
    } else {
      warninTitle = decodedResponse['answer'];
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 5),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * (1 / 10),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * (8 / 10),
                  child: TextField(
                    controller: searchTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: 'Искать тавар',
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(glob.dark),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    onPressed: () {
                      reqSearch();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Icon(Icons.arrow_circle_right_rounded, size: 30),
                    ))
              ],
            ),
          ),
          RefreshIndicator(
            onRefresh: () {
              return reqSearch();
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * (6 / 10),
              child: data.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        String imgLink = data[index]['img_link'].toString();
                        String name = data[index]['name'].toString();
                        String link = data[index]['link'].toString();
                        var price = data[index]['price'];
                        return Container(
                          margin: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            onLongPress: () {
                              reqAdd(data[index]);
                            },
                            onPressed: () {
                              _launchUrl(Uri.parse(link));
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(glob.dark),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  // Change your radius here
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  width: 100,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.network(
                                        imgLink,
                                      )),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 230,
                                        child: Text(
                                          name,
                                          softWrap: true,
                                          style: const TextStyle(fontSize: 13),
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
                      itemCount: data.length,
                    )
                  : ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Center(
                            child: Text('no data'),
                          ),
                        )
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
