import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_project/screens/webView.dart';
import 'package:github_project/util/toasts.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../../data/network_helper.dart';
import '../../models/userRepo_model.dart';

class FutureRepo extends StatefulWidget {
  final url;

  const FutureRepo({Key? key, this.url}) : super(key: key);

  @override
  State<FutureRepo> createState() => _FutureRepoState();
}

class _FutureRepoState extends State<FutureRepo> {
  final TextEditingController _searchController = TextEditingController();
  var UserRepoData;
  Future<UserRepoModel?>? userRepo;
  @override
  void initState() {
    getUserRepos();

    print("userData===>$userRepo");

    super.initState();
  }

  Future<List<dynamic>> getUserRepos() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        UserRepoData = data;
      });
      print("data====>$data");
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> search(String query) async {
    var url = "https://api.github.com/users/$query/repos";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        UserRepoData = data;
      });
      print("search data===>$UserRepoData");
      return data;
    } else {
      ToastUtil.show("Something went Wrong");
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(bottom: 15.0, top: 4, right: 8, left: 8),
          child: TextField(
            maxLines: null, controller: _searchController,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
            onChanged: (value) async {
              setState(() {
                search(value);
              });
            },
            decoration: InputDecoration(
              filled: true,
              focusColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              // filled: true,

              fillColor: Colors.white,
              constraints: const BoxConstraints(maxHeight: 50),

              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                  )),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12)),
              enabled: true,
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12)),
            ),
            // keyboardType: kType,
          ),
        ),
        UserRepoData != null
            ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: UserRepoData.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => WebViewRepo(
                                    name: UserRepoData[index]["name"],
                                    url: UserRepoData[index]["html_url"],
                                  )));
                    },
                    child: ListTile(
                      title: Text(
                        UserRepoData[index]["name"] ?? "No data",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${UserRepoData[index]["forks_count"]} Forks"),
                          Text(
                              "${UserRepoData[index]["stargazers_count"]} Stars"),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Colors.grey, height: 1);
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }
}
