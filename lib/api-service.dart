import "dart:convert";
import "package:http/http.dart" as http;

class ApiServices {
  final String baseUrl = "https://reqres.in/api";

  Future<String> login(String email, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}));

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? 'Failed to login');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$id"));

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load user');
    }
  }
}