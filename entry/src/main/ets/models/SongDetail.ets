import { Album } from "./Album"
import { Artist } from "./Artist"

export class SongDetail{
  name: string
  id: number
  position: number
  alias: string[]
  status: number
  fee: number
  copyrightId: number
  disc: string
  no: number
  popularity: number
  score: number
  starredNum: number
  duration: number
  playedNum: number
  dayPlays: number
  hearTime: number
  artists:Artist[]
  album:Album

  constructor(name: string, id: number, position: number, alias:string [], status: number, fee: number, copyrightId: number,
    disc: string, no: number, popularity: number, score: number, starredNum: number, duration: number,
    playedNum: number, dayPlays: number, hearTime: number, artists: Artist[], album: Album) {
    this.name = name
    this.id = id
    this.position = position
    this.alias = alias
    this.status = status
    this.fee = fee
    this.copyrightId = copyrightId
    this.disc = disc
    this.no = no
    this.popularity = popularity
    this.score = score
    this.starredNum = starredNum
    this.duration = duration
    this.playedNum = playedNum
    this.dayPlays = dayPlays
    this.hearTime = hearTime
    this.artists = artists
    this.album = album
  }

}