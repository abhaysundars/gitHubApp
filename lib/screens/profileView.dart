import 'package:flutter/material.dart';
import 'package:github_project/screens/widgets/repo_data.dart';
import '../data/network_helper.dart';
import '../models/user_model.dart';

class ProfileView extends StatefulWidget {
  final url;
  final repo;
  const ProfileView({Key? key, this.url, this.repo}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Future<UserModel?>? userData;

  @override
  void initState() {
    userData = NetworkHelper().getUser(context: context, url: widget.url);
    debugPrint("userData===>$userData");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            "GitHub Searcher",
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
      body: SafeArea(
        child: FutureBuilder(
            future: userData,
            builder:
                (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
              if (snapshot.hasData) {
                // getUserRepos(snapshot.data!.reposUrl.toString());
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(snapshot.data!.avatarUrl!),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  buildText("User Name:", snapshot.data!.name!),
                                  buildText(
                                      "Email:", snapshot.data!.email ?? ""),
                                  buildText("Location:",
                                      snapshot.data!.location ?? ""),
                                  buildText("Followers:",
                                      snapshot.data!.followers.toString()),
                                  buildText("Following:",
                                      snapshot.data!.following.toString()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data!.bio ?? "No bio Available!!!!",
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 15),
                        ),
                      ),
                      FutureRepo(
                        url: snapshot.data!.reposUrl.toString(),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child:
                      Text("Something Went Wrong!!! \nAPI rate limit exceeded"),
                );
              }
            }),
      ),
    );
  }

  Widget buildText(String Str, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      /*child: Text(
        Str,
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
      ),*/
      child: RichText(
          text: TextSpan(
              text: Str,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 12),
              children: [
            TextSpan(
                text: "\t$value",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    fontSize: 15))
          ])),
    );
  }
}
