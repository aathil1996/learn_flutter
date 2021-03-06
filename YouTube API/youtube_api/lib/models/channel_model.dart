import 'package:flutter/foundation.dart';
import 'package:youtube_api/models/video_model.dart';

class Channel {
  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscribeCount;
  final String videoCount;
  final String uploadPlaylistId;
  List<Video> videos;

  Channel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscribeCount,
    this.videoCount,
    this.uploadPlaylistId,
    this.videos 
  });


factory Channel.fromMap(Map<String, dynamic> map){
  return Channel(
    id: map['id'],
    title: map['snipper']['title'],
    profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
    subscribeCount: map['statistics']['subscribeCount'],
    videoCount: map['statistics']['videoCount'],
    uploadPlaylistId: map['contentDetails']['relatedPlayLists']['uploads']
  );
}
}