import { Song } from "../models/Song";
import { media } from "@kit.MediaKit";
import { http } from "@kit.NetworkKit";
import { SongDetailResponse } from "../models/SongDetailResponse";
import { request } from "@kit.BasicServicesKit";
import { JSON } from "@kit.ArkTS";
import { LrcSearchResponse } from "../models/LrcSearchResponse";
import { AVSessionUtil } from "./AVSessionUtil";
import { avSession } from "@kit.AVSessionKit";

export class AudioPlayerUtil{


  static  avPlayer:media.AVPlayer | undefined = undefined

  static async playSong(song:Song){
    //console.log(`play:${song.id}`)
    if (AudioPlayerUtil.avPlayer){
      AudioPlayerUtil.avPlayer.release()
      AudioPlayerUtil.avPlayer = undefined
    }
    AudioPlayerUtil.avPlayer = await media.createAVPlayer()

    AudioPlayerUtil.avPlayer.on("stateChange",(state)=>{
      AppStorage.setOrCreate("avplayerState",state)
      if (state == "initialized"){
        AudioPlayerUtil.avPlayer?.prepare()
        AVSessionUtil.setAVPlayerState(avSession.PlaybackState.PLAYBACK_STATE_INITIAL)
      }else if (state == "prepared"){
        AudioPlayerUtil.avPlayer?.play()
        AVSessionUtil.setAVPlayerState(avSession.PlaybackState.PLAYBACK_STATE_PREPARE)
      }else if (state == "playing"){
        console.log('音乐播放中....')
        AVSessionUtil.setAVPlayerState(avSession.PlaybackState.PLAYBACK_STATE_PLAY)
      }else if (state == "paused"){
        console.log('音乐已经暂停...')
        AVSessionUtil.setAVPlayerState(avSession.PlaybackState.PLAYBACK_STATE_PAUSE)
      }else if (state == "stopped"){
        console.log('播放器已经停止...')
        AVSessionUtil.setAVPlayerState(avSession.PlaybackState.PLAYBACK_STATE_STOP)
      }else if (state == "released"){
        console.log('播放器已释放...')
        AVSessionUtil.setAVPlayerState(avSession.PlaybackState.PLAYBACK_STATE_RELEASED)
      }
    })

    //播放时间
    AudioPlayerUtil.avPlayer.on("durationUpdate",totalTime=>{
      AppStorage.setOrCreate("duration",totalTime)
    })

    //播放进度
    AudioPlayerUtil.avPlayer.on("timeUpdate",time=>{
      AppStorage.setOrCreate("currentTime",time)
    AVSessionUtil.setAVPlaybackTime(time)
    })



    AudioPlayerUtil.avPlayer.url =`http://music.163.com/song/media/outer/url?id=${song.id}.mp3`

    //查询
    AudioPlayerUtil.getSongDetail(song.id)
    AudioPlayerUtil.getSongLrc(song.id)
  }

  static getSongLrc(id:number){
    let httpRequest = http.createHttp()
    let url = "http://music.163.com/api/song/lyric"
    let options:http.HttpRequestOptions = {
      method:http.RequestMethod.GET,
      extraData:{
        id:id+"",
        lv:"-1",
        kv:"-1",
        tv:"-1"
      }
    }
    httpRequest.request(url,options).then(request=>{
      let jsonStr = request.result as string
      //console.log(jsonStr)
      let LrcSearchResponse = JSON.parse(jsonStr) as  LrcSearchResponse
      if(LrcSearchResponse.code = 200){
        console.log(LrcSearchResponse.lrc.lyric)
        AppStorage.setOrCreate("lyric",LrcSearchResponse.lrc.lyric)
      }
    })
  }

  static getSongDetail(id:number){
    let httpRequest = http.createHttp()
    let url = "http://music.163.com/api/song/detail/"
    let options : http.HttpRequestOptions={
      method:http.RequestMethod.GET,
      extraData:{
        id:id+"",
        ids:`[${id}]`
      }
    }
    httpRequest.request(url,options).then((response)=>{
      let jsonStr = response.result as string
      //console.log(jsonStr)
      let songDetailResponse = JSON.parse(jsonStr) as SongDetailResponse
     // console.log(songDetailResponse.code+"~~~~~~~")
      if(songDetailResponse.code == 200){
        let songDetail =  songDetailResponse.songs[0]

        AppStorage.setOrCreate("currentSongDetail",songDetail)

        AVSessionUtil.setAVMetadate(songDetail)


      }

    })

  }

  //下一曲//
  static playNextSong(){
    let currentIndex = AppStorage.get("currentIndex") as number
    let songList:Song[] = AppStorage.get("songList") as Song[]
    let nextIndex = currentIndex == songList.length-1 ? 0 :currentIndex+1
    let song = songList[nextIndex]
    while (song.fee != 0 && song.fee != 8){
      currentIndex = nextIndex
      nextIndex = currentIndex == songList.length-1 ? 0 :currentIndex+1
      song = songList[nextIndex]
    }
    AudioPlayerUtil.playSong(song)
    AppStorage.setOrCreate("currentIndex",nextIndex)

  }

  static playPrevSong(){
    let currentIndex = AppStorage.get("currentIndex") as number
    let songList:Song[] = AppStorage.get("songList") as Song[]
    let playPrevIndex = currentIndex == songList.length+1 ? 0 :currentIndex-1
    let song = songList[playPrevIndex]
    while (song.fee != 0 && song.fee != 8){
      currentIndex = playPrevIndex
      playPrevIndex = currentIndex == songList.length+1 ? 0 :currentIndex-1
      song = songList[playPrevIndex]
    }
    AudioPlayerUtil.playSong(song)
    AppStorage.setOrCreate("currentIndex",playPrevIndex)
  }

}