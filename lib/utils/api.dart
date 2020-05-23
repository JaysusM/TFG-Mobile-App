import 'package:meta/meta.dart';
import 'package:http/http.dart';

class Api {
  static Api _api;
  static const String API_URL = "https://floating-brook-69790.herokuapp.com/";
  final Client httpClient;
  
  Api._({@required this.httpClient}): assert(httpClient != null);

  static getInstance() {
    if(_api == null) {
      Client client = new Client();
      _api = Api._(httpClient: client);
    }

    return _api;
  }

  Future<Response> signIn(username, password, language) async {
    const String url = API_URL + "user/signIn";
    Map<String, String> body = new Map<String, String>();
    body["username"] = username;
    body["password"] = password;
    body["language"] = language;
    return this.httpClient.post(url, body: body);
  }

    Future<Response> signUp(username, password, language) async {
    const String url = API_URL + "user/signUp";
    Map<String, String> body = new Map<String, String>();
    body["username"] = username;
    body["password"] = password;
    body["language"] = language;
    return this.httpClient.post(url, body: body);
  }

  Future<Response> addNewValue(userId, location, value, language) async {
    const String url = API_URL + "measurement/new";
    Map<String, String> body = new Map<String, String>();
    body["userId"] = userId;
    body["coordenates"] = location;
    body["value"] = value;
    body["language"] = language;
    return this.httpClient.post(url, body: body);
  }
}