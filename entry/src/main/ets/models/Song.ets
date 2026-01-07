import { Album } from "./Album"
import { Artist } from "./Artist"

export class Song{
  album:Album
  fee:number
  duration:number
  artists:Artist[]
  copyrightId:number
  mvid:number
  name:string
  alias:string[]
  id:number
  mark:number
  status:number

  constructor(album: Album, fee: number, duration: number, artists: Artist[], copyrightId: number, mvid: number,
    name: string, alias: string[], id: number, mark: number, status: number) {
    this.album = album
    this.fee = fee
    this.duration = duration
    this.artists = artists
    this.copyrightId = copyrightId
    this.mvid = mvid
    this.name = name
    this.alias = alias
    this.id = id
    this.mark = mark
    this.status = status
  }

}