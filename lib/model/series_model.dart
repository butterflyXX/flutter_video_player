import 'package:video_player/model/item_model.dart';

class SeriesModel {
  final String id;
  final String name;
  final String desc;
  final String labels;
  final List<String> seriesTag;
  final String cover;
  final int episodeCount;
  final int viewCount;
  final int followCount;
  final int finishStatus;
  final int viewEpisode;
  final int startEpisode;
  final bool following;
  final int episodePrice;
  final String lang;
  final String payMode;
  final bool free;
  final List<ItemModel> episodeList;
  ItemModel episode;
  final bool empty;

  SeriesModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.labels,
    required this.seriesTag,
    required this.cover,
    required this.episodeCount,
    required this.viewCount,
    required this.followCount,
    required this.finishStatus,
    required this.viewEpisode,
    required this.startEpisode,
    required this.following,
    required this.episodePrice,
    required this.lang,
    required this.payMode,
    required this.free,
    required this.episodeList,
    required this.episode,
    required this.empty,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json) => SeriesModel(
    id: json["id"],
    name: json["name"],
    desc: json["desc"],
    labels: json["labels"],
    seriesTag: List<String>.from(json["series_tag"].map((x) => x)),
    cover: json["cover"],
    episodeCount: json["episode_count"],
    viewCount: json["view_count"],
    followCount: json["follow_count"],
    finishStatus: json["finish_status"],
    viewEpisode: json["view_episode"],
    startEpisode: json["start_episode"],
    following: json["following"],
    episodePrice: json["episode_price"],
    lang: json["lang"],
    payMode: json["pay_mode"],
    free: json["free"],
    episodeList: List<ItemModel>.from(json["episode_list"].map((json) => ItemModel.fromJson(json))),
    episode: ItemModel.fromJson(json["episode"]),
    empty: json["_"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "desc": desc,
    "labels": labels,
    "series_tag": List<dynamic>.from(seriesTag.map((x) => x)),
    "cover": cover,
    "episode_count": episodeCount,
    "view_count": viewCount,
    "follow_count": followCount,
    "finish_status": finishStatus,
    "view_episode": viewEpisode,
    "start_episode": startEpisode,
    "following": following,
    "episode_price": episodePrice,
    "lang": lang,
    "pay_mode": payMode,
    "free": free,
    "episode_list": List<dynamic>.from(episodeList.map((x) => x)),
    "episode": episode.toJson(),
    "_": empty,
  };
}