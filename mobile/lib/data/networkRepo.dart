import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:dio/dio.dart' as dio;

//creates a new patient and return there UUID
//Use when starting to record five audio files
Future<String> new_patient(String user) async
{
  var url = "https://api.byu-dept-nursingsteth-prd.amazon.byu.edu/beats/patients";

  // var request = await post(url, body: JsonEncoder().convert({"created_by": user}));

  // final response_body = json.decode(request.body);

  // String id = response_body["id"];

  // return id;
  return Future.value('10');
}

//Writes one file for a patient to the db under the user's credentials
dynamic upload_file(String location, String user, String patient_id, File file) async //user is an email
{
  var url = "https://api.byu-dept-nursingsteth-prd.amazon.byu.edu/beats/patients/"+patient_id+"/recordings";

  var body = {"location": location,
              "created_by": user};

  Response file_url = await post(url, body: JsonEncoder().convert(body));

  final response_body = json.decode(file_url.body);

  var request = await put(response_body["url"], body: file.readAsBytesSync());

  return request;
}

//For paginating on the admin page. If token is an empty String, sends first search back
//This will return a token for requesting the next batch of users
//To request the next batch of users, run the query again but use the token we had saved
Future<dynamic> all_patients(String token) async //return next token and all patients
{
  var url = "https://api.byu-dept-nursingsteth-prd.amazon.byu.edu/beats/patients/"+token;

  var request = await get(url);

  final response_body = json.decode(request.body);

  return(response_body);

}

//Returns a list of URLs that are used in get_recordings to ask for the specific wav file
Future<List<String>> patient_recordings(String patient_id) async //returns patients recordings as a list
{
  var url = "https://api.byu-dept-nursingsteth-prd.amazon.byu.edu/beats/patients/"+patient_id+"/recordings";
  var request = await get(url);
  final response_body = json.decode(request.body);
  List<String> recordings = [];
  for (int i  = 0; i < response_body["recordings"].length; i++)
  {
    final url = response_body["recordings"].elementAt(i);
    recordings.add(url["url"]);    
  }
  return recordings;
}

//Use one of the URLs queried from patient_recordings to get the WAV file
Future<dynamic> get_recording(String r_url) async //get one recording from url
{
  dio.Response<List<int>> rs = await dio.Dio().get<List<int>>(r_url,
  options: dio.Options(responseType: dio.ResponseType.bytes),
  );
  return rs.data;
}

///Pass a string of a filter
Future<dynamic> filter_list(Map<String, String> filter) async //filter all patients
{
  var url = "https://api.byu-dept-nursingsteth-prd.amazon.byu.edu/beats/patients"+filter[''];

  var request = await get(url);

  final response_body = json.decode(request.body);

  return response_body;
}

//body format { "patient": { "tags": ["tag1", "tag2"], "abnormal": true}};
//Used when the administrator diagnoses and adds tags
dynamic update(String patient_id, body) async 
{
  var url = "https://api.byu-dept-nursingsteth-prd.amazon.byu.edu/beats/patients/"+patient_id;

  var request = await put(url, body: JsonEncoder().convert(body));

  return request;
}