import 'package:dio/dio.dart';
import '../helpers/api_client.dart';
import '../model/user.dart';
import '../helpers/user_info.dart';

class UserService {
  Future<User?> register(User user) async {
    try {
      final Response response =
          await ApiClient().post('users', data: user.toJson());
      return User.fromJson(response.data);
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<bool> login(String name, String password) async {
    try {
      final Response response = await ApiClient().get('users');
      final List users = response.data;

      var matchedUser = users.firstWhere(
          (u) => u['name'] == name && u['password'] == password,
          orElse: () => null);

      if (matchedUser != null) {
        // Save user info
        await UserInfo().setToken(matchedUser['id']);
        await UserInfo().setUserID(matchedUser['id']);
        await UserInfo().setUsername(matchedUser['name']);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
}
