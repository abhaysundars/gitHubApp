import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_project/data/network_helper.dart';
import 'package:github_project/screens/profileView.dart';
import 'package:github_project/screens/webView.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../models/github_model.dart';
import '../util/toasts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  Future<GitHubModel?>? repository;
  initState() {
    //searchRepositories(_searchController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: SizedBox(),
          leadingWidth: 5,
          backgroundColor: Colors.teal,
          title: Center(
            child: Text(
              "GitHub Searcher",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.0, top: 4, right: 8, left: 8),
              child: TextField(
                maxLines: null, controller: _searchController,
                style: TextStyle(color: Colors.black54, fontSize: 14),
                onChanged: (value) async {
                  setState(() {
                    repository = NetworkHelper()
                        .getGitHubDetails(context: context, str: value);
                  });
                  // setState(() {
                  //   _repositories = repositories.toList();
                  // });
                },
                decoration: InputDecoration(
                  filled: true, hintText: "Search for Repositories",
                  focusColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  // filled: true,

                  fillColor: Colors.white,
                  constraints: BoxConstraints(maxHeight: 50),

                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.black12,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black12)),
                  enabled: true,
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black12)),
                ),
                // keyboardType: kType,
              ),
            ),
            FutureBuilder(
                future: repository,
                builder: (BuildContext context,
                    AsyncSnapshot<GitHubModel?> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.items!.length,
                      itemBuilder: (context, index) {
                        print("length==>$repository");
                        // print("_repositories.length==>${_repositories.length}");
                        // var repository = _repositories[index];
                        // print("repository==>${_repositories[0].items![index].name!}");
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ProfileView(
                                        repo: snapshot.data!.items![index]
                                            .owner!.reposUrl,
                                        url: snapshot
                                            .data!.items![index].owner!.url)));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                clipBehavior: Clip.hardEdge,
                                child: Image.network(snapshot
                                    .data!.items![index].owner!.avatarUrl!),
                              ),
                              title: Text(snapshot.data!.items![index].name!),
                              // //subtitle: Text(repository.description),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 2,
                          color: Colors.grey,
                        );
                      },
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(child: Lottie.asset('assets/search.json'));
                  }
                }),
          ],
        )),
      ),
    );
  }
}
