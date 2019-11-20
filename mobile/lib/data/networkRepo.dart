import 'dart:io';
import 'dart:convert';

Future<dynamic> executeQuery(var url, Map map) async {
  try{
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.write(json.encode(map));
    HttpClientResponse response = await request.close();
    var reply = await response.cast<List<int>>().transform(utf8.decoder).join();
    print(reply);
    httpClient.close();
    return reply;
  } catch(e) {
    print(e);
  }
}

createPatient() async {
  var url = 'https://89z1b0o7y3.execute-api.us-west-2.amazonaws.com/dev/patients';
  Map map = {};
  var response;
  try {
    response = await executeQuery(url, map);
  } catch(e) {
    print(e);
  }
  return response;
}