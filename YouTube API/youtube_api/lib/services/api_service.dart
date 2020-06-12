import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:youtube_api/models/channel_model.dart';
import 'package:youtube_api/models/video_model.dart';
import 'package:youtube_api/utilities/keys.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();  
  
  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToke = '';

  Future<Channel> fetchChannel({String channelId}) async{
    Map<String, String> parameters = {
      'part' : 'snippet, contentDetails, statistics',
      'id': channelId,
      'key' : API_KEY,
    };

    Uri uri = Uri.https(
      _baseUrl,
      'youtube/v3/channels',
      parameters
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',

    };

    //Get channel
    var response = await http.get(uri, headers:headers);
    if (response.statusCode == 200){
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      //Fetch videos
      channel.videos = await fetchVideosFromPlaylist(
        playlistID: channel.uploadPlaylistId,
      );

      return channel;
    }
    else{
      throw json.decode(response.body)['error']['message'];    }
    
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistID}) async{
    Map<String, String> parameters = {
      'part' : 'snippet',
      'playlistID': playlistID,
      'maxResults' : '8',
      'pageTolen' : _nextPageToke,
      'key' : API_KEY,
    };

  Uri uri = Uri.https(
      _baseUrl,
      'youtube/v3/playListItems',
      parameters,
    );
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'applicaiton/json',
  };

  var response = await http.get(uri, headers: headers);
  if(response.statusCode == 200){
    var data = json.decode(response.body);

    _nextPageToke = data['nextPageToken'] ?? '';
    List<dynamic> videoJson = data['items'];

    //Fetch first eight videos
    List<Video> videos = [];
    videoJson.forEach(
      (json) => videos.add(
        Video.fromMap(json['snippet']),
      ),
    );

    return videos;

  }

  else{
    throw json.decode(response.body)['error']['message'];
  }
  }
}