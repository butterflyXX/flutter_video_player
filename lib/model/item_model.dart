class ItemModel {
  final String id;
  final String seriesId;
  final String name;
  final String cover;
  final String videoUrl;
  final String m3U8Url;
  final String externalAudioH264M3U8;
  final String externalAudioH265M3U8;
  final List<String> audio;
  final int index;
  final bool unlock;
  final int duration;
  final int episodePrice;
  final String videoType;
  final bool popupContentModelDartNew;
  final int updateTime;

  ItemModel({
    required this.id,
    required this.seriesId,
    required this.name,
    required this.cover,
    required this.videoUrl,
    required this.m3U8Url,
    required this.externalAudioH264M3U8,
    required this.externalAudioH265M3U8,
    required this.audio,
    required this.index,
    required this.unlock,
    required this.duration,
    required this.episodePrice,
    required this.videoType,
    required this.popupContentModelDartNew,
    required this.updateTime,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json["id"],
    seriesId: json["series_id"],
    name: json["name"],
    cover: json["cover"],
    videoUrl: json["video_url"],
    m3U8Url: json["m3u8_url"],
    externalAudioH264M3U8: json["external_audio_h264_m3u8"],
    externalAudioH265M3U8: json["external_audio_h265_m3u8"],
    audio: List<String>.from(json["audio"].map((x) => x)),
    index: json["index"],
    unlock: json["unlock"],
    duration: json["duration"],
    episodePrice: json["episode_price"],
    videoType: json["video_type"],
    popupContentModelDartNew: json["new"],
    updateTime: json["update_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "series_id": seriesId,
    "name": name,
    "cover": cover,
    "video_url": videoUrl,
    "m3u8_url": m3U8Url,
    "external_audio_h264_m3u8": externalAudioH264M3U8,
    "external_audio_h265_m3u8": externalAudioH265M3U8,
    "audio": List<dynamic>.from(audio.map((x) => x)),
    "index": index,
    "unlock": unlock,
    "duration": duration,
    "episode_price": episodePrice,
    "video_type": videoType,
    "new": popupContentModelDartNew,
    "update_time": updateTime,
  };
}