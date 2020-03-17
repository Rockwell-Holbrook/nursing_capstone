import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:dio/dio.dart' as dio;

new_patient(user) async //creates a new patient and return there UUID
{
  var url = "https://api.byu-dept-nursingsteth-dev.amazon.byu.edu/beats/patients";

  var request = await post(url, body: JsonEncoder().convert({"created_by": user}));

  final response_body = json.decode(request.body);

  var id = response_body["id"];

  return id;
}

upload_file(user, patient_id) async //user is an email
{
  var url = "https://api.byu-dept-nursingsteth-dev.amazon.byu.edu/beats/patients/"+patient_id+"/recordings";

  var body = {"created_by": user };

  Response file_url = await post(url, body: JsonEncoder().convert(body));

  final response_body = json.decode(file_url.body);

  var request = await put(response_body["url"], body: File('audio1.wav').readAsBytesSync());

}

all_patients(token) async //return next token and all patients
{
  var url = "https://api.byu-dept-nursingsteth-dev.amazon.byu.edu/beats/patients/"+token;

  var request = await get(url);

  final response_body = json.decode(request.body);

  return(response_body);

}

patient_recordings(patient_id) async //returns patients recordings as a list
{
  var url = "https://api.byu-dept-nursingsteth-dev.amazon.byu.edu/beats/patients/"+patient_id+"/recordings";

  var request = await get(url);

  final response_body = json.decode(request.body);

  List<List> recordings = [];
  for (int i  = 0; i < response_body["recordings"].length; i++)
  {
    final url = response_body["recordings"].elementAt(i);

    var r_url  =  url["url"];

    var single = await get_recording(r_url);
    recordings.add(single);
  }
    return recordings;
}


get_recording(r_url) async //get one recording from url
{
  dio.Response<List<int>> rs = await dio.Dio().get<List<int>>(r_url,
  options: dio.Options(responseType: dio.ResponseType.bytes),
  );
  return rs.data;
}

filter_list(filter) async //filter all patients
{
  var url = "https://api.byu-dept-nursingsteth-dev.amazon.byu.edu/beats/patients"+filter;

  var request = await get(url);

  final response_body = json.decode(request.body);

  return response_body;
}

//body format { "patient": { "tags": ["tag1", "tag2"], "abnormal": true}};
update(patient_id, body) async 
{
  var url = "https://api.byu-dept-nursingsteth-dev.amazon.byu.edu/beats/patients/"+patient_id;

  var request = await put(url, body: JsonEncoder().convert(body));
}

// import 'dart:io';
// import 'dart:convert';

// Future<dynamic> executeQuery(var url, Map map) async {
//   try{
//     HttpClient httpClient = new HttpClient();
//     HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
//     request.headers.set('content-type', 'application/json');
//     request.write(json.encode(map));
//     HttpClientResponse response = await request.close();
//     var reply = await response.cast<List<int>>().transform(utf8.decoder).join();
//     print(reply);
//     httpClient.close();
//     return reply;
//   } catch(e) {
//     print(e);
//   }
// }

// createPatient() async {
//   var url = 'https://89z1b0o7y3.execute-api.us-west-2.amazonaws.com/dev/patients';
//   Map map = {};
//   var response;
//   try {
//     response = await executeQuery(url, map);
//   } catch(e) {
//     print(e);
//   }
//   return response;
// }

// Future<List<dynamic>> getPatients() async {
//   return Future(() {
//     List<dynamic> items =
//       [
//         {
//           "id": "1111",
//           "date": "01-01-1111",
//           "recorder": "JoeAnn Meyers",
//           "abnormal": "true"
//         },
//         {
//           "id": "2222",
//           "date": "02-02-2222",
//           "recorder": "JoeAnn Meyers",
//           "abnormal": "false"
//         },
//         {
//           "id": "3333",
//           "date": "03-03-3333",
//           "recorder": "Billy Joe",
//           "abnormal": "true"
//         }
//       ];

//     return items;
//     });
//   }