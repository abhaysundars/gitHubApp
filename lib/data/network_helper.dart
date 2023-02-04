import 'dart:convert';
import 'dart:io';
import 'package:github_project/models/github_model.dart';
import 'package:github_project/models/userRepo_model.dart';
import 'package:github_project/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import '../util/toasts.dart';

class NetworkHelper {
  Future<GitHubModel?>? getGitHubDetails(
      {required BuildContext context, required String str}) async {
    http.Response? response;

    response = await _getRequest(
      context: context,
      url: 'https://api.github.com/search/repositories?q=$str',
      header: {
        "Content-Type": "application/json",
      },
    );
    if (response?.statusCode == 200) {
      return GitHubModel.fromJson(jsonDecode(response!.body));
    } else {
      var data = jsonDecode(response!.body);

      ToastUtil.show(data["errors"][0]["message"] ??
          "Server Error Please try After sometime");
      debugPrint(response.body);
    }
  }

  Future<UserModel?>? getUser(
      {required BuildContext context, required String url}) async {
    http.Response? response;

    response = await _getRequest(
      context: context,
      url: url,
      header: {
        "Content-Type": "application/json",
      },
    );
    if (response?.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response!.body));
    } else {
      var data = jsonDecode(response!.body);

      ToastUtil.show(data["errors"][0]["message"] ??
          "Server Error Please try After sometime");
      debugPrint(response.body);
    }
  }

  Future<UserRepoModel?>? getUserRepo(
      {required BuildContext context, required String url}) async {
    http.Response? response;

    response = await _getRequest(
      context: context,
      url: url,
      header: {
        "Content-Type": "application/json",
      },
    );
    if (response?.statusCode == 200) {
      return UserRepoModel.fromJson(jsonDecode(response!.body));
    } else {
      var data = jsonDecode(response!.body);

      ToastUtil.show(data["errors"][0]["message"] ??
          "Server Error Please try After sometime");
      debugPrint(response.body);
    }
  }

  Future<http.Response?> _getRequest({
    required BuildContext context,
    required String url,
    Map<String, String>? header,
  }) async {
    http.Response? response;

    try {
      response = await http.get(Uri.parse(url), headers: header ?? {});
      debugPrint("$url---$header-->${response.body}");
    } on SocketException {
      ToastUtil.show("Please check your internet connection");
    } catch (e) {
      ToastUtil.show(e.toString());
      // rethrow;
    }
    return response;
  }
}
