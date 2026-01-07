import { avSession } from "@kit.AVSessionKit";
import { Song } from "../models/Song";
import { SongDetail } from "../models/SongDetail";
import { wantAgent } from "@kit.AbilityKit";
import { AudioPlayerUtil } from "./AudioPlayerUtil";

export class AVSessionUtil{
  static session:avSession.AVSession | undefined
  static setAVMetadate(songDetail?:SongDetail){
      if (AVSessionUtil.session){
        let date:avSession.AVMetadata = {
          assetId:songDetail?songDetail.id+"":"1",
          title:songDetail?songDetail.name:"歌曲名称",
          artist:songDetail?songDetail.artists[0].name:"歌手名称",
          duration:songDetail?songDetail.duration:0,
          mediaImage:songDetail?songDetail.album.picUrl:"http://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg"

        }
        AVSessionUtil.session.setAVMetadata(date)
      }
  }

  static setAVPlayerState(state:avSession.PlaybackState){
    if (AVSessionUtil.session){
      let avPlaybackState:avSession.AVPlaybackState = {
        state:state
      }
      AVSessionUtil.session.setAVPlaybackState(avPlaybackState)
    }
  }

  static setAVQueue(songList:Song[]){
    if (AVSessionUtil.session){
      let items:avSession.AVQueueItem[]= []
      songList.forEach((song,index)=>{
        let queueItem:avSession.AVQueueItem = {
          itemId:index,
          description:{
            assetId:song.id+"",
            title:song.name,
            artist:song.artists[0].name,
            mediaImage:song.album.picUrl
          }
        }
        items.push(queueItem)
      })
      AVSessionUtil.session.setAVQueueItems(items)
      AVSessionUtil.session.setAVQueueTitle('歌曲播放列表')
    }
  }

  static setLanuchAbility(){
    if (AVSessionUtil.session){
      let wantAgentInfo:wantAgent.WantAgentInfo = {
        wants:[
          {
            bundleName:'cn.edu.whxy.wy_music',
            abilityName:'EntryAbility'
          }
        ],
        requestCode:0,
        operationType:2,
        wantAgentFlags:[wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      }
wantAgent.getWantAgent(wantAgentInfo).then((agent)=>{
  AVSessionUtil.session?.setLaunchAbility(agent)
})

    }
  }

  static setAVPlaybackTime(time:number){
    if (AVSessionUtil.session){
      let state:avSession.AVPlaybackState={
        position:{
          elapsedTime:time,
          updateTime:new Date().getTime()
        }
      }
      AVSessionUtil.session.setAVPlaybackState(state)
    }
  }

  static onCtrlCommand(){
    if (AVSessionUtil.session){
      AVSessionUtil.session.on('play',()=>{
        AudioPlayerUtil.avPlayer?.play()
      })
      AVSessionUtil.session.on('pause',()=>{
        AudioPlayerUtil.avPlayer?.pause()
      })
      AVSessionUtil.session.on('playNext',()=>{
        AudioPlayerUtil.playNextSong()
      })
      AVSessionUtil.session.on('playPrevious',()=>{
        AudioPlayerUtil.playPrevSong()
      })
      AVSessionUtil.session.on('seek',(time)=>{
        AudioPlayerUtil.avPlayer?.seek(time)
      })
      AVSessionUtil.session.on('setSpeed',(speed)=>{

      })
      AVSessionUtil.session.on('toggleFavorite',(assetId)=>{

      })
      AVSessionUtil.session.on('setLoopMode',(mode)=>{

      })
    }
  }



}