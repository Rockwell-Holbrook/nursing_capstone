import 'dart:collection';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'user.dart';

String dest = 'https://api.byu-dept-nursingsteth-prd.amazon.byu.edu';

///Gets the jwt token tied to the user's session
///Returns a map that contains the authorization token
Future<Map<String,String>> authorize() async 
{
  User user = new User();
  
  String jwt = await user.getSessionToken();
  
  Map<String,String> headers = new HashMap();
  
  headers['Authorization'] = jwt;
  
  return headers;
}

//creates a new patient and return there UUID
//Use when starting to record five audio files
Future<String> new_patient(String user) async
{
  var url = dest + '/patients';

  var header = await authorize();

  var request = await post(
      url, headers: header, body: JsonEncoder().convert({"created_by": user}));

  final response_body = json.decode(request.body);

  String id = response_body["id"];

  return id;
}

//Writes one file for a patient to the db under the user's credentials
dynamic upload_file(String location, String user, String patient_id, File file) async //user is an email
{
  var url = dest + "/patients/"+patient_id+"/recordings";

  var header = await authorize();

  var body = {"pat_id": patient_id,
              "location": location,
              "created_by": user};

  Response file_url = await post(
      url, headers: header, body: JsonEncoder().convert(body));

  final response_body = json.decode(file_url.body);

  var request = await put(response_body["url"], body: file.readAsBytesSync());

  return request;
}

//For paginating on the admin page. If token is an empty String, sends first search back
//This will return a token for requesting the next batch of users
//To request the next batch of users, run the query again but use the token we had saved
Future<dynamic> all_patients(String token) async //return next token and all patients
{
  var url = dest + "/patients/"+token;

  var header = await authorize();

  var request = await get(
      url, headers: header);

  final response_body = json.decode(request.body);

  return(response_body);
}

//Returns a list of URLs that are used in get_recordings to ask for the specific wav file
Future<List<String>> patient_recordings(String patient_id) async //returns patients recordings as a list
{
  var url = dest + "/patients/"+patient_id+"/recordings";
  
  var header = await authorize();

  var request = await get(
      url, headers: header);
  
  final response_body = json.decode(request.body);
  
  List<String> recordings = [];
  
  for (int i  = 0; i < response_body["recordings"].length; i++)
  {
    final url = response_body["recordings"].elementAt(i);
    recordings.add(url["url"]);    
  }
  
  return recordings;
}

///Pass a string of a filter
Future<dynamic> filter_list(Map<String, String> filter) async //filter all patients
{
  var url = dest + "/beats/patients"+filter[''];

  var header = await authorize();

  var request = await get(
      url, headers: header);

  final response_body = json.decode(request.body);

  return response_body;
}

//body format { "patient": { "tags": ["tag1", "tag2"], "abnormal": true}};
//Used when the administrator diagnoses and adds tags
dynamic update(String patient_id, body) async 
{
  var url = dest + "/beats/patients/"+patient_id;

  var header = await authorize();

  var request = await put(
      url, headers: header, body: JsonEncoder().convert(body));

  return request;
}