import { Artist } from "./Artist"

export class Album{
  publishTime:number
  size:number
  artist:Artist
  copyrightId:number
  name:string
  id:number
  picId:number
  mark:number
  status:number
  picUrl:string

  constructor(publishTime: number, size: number, artist: Artist, copyrightId: number, name: string, id: number,
    picId: number, mark: number, status: number, picUrl: string) {
    this.publishTime = publishTime
    this.size = size
    this.artist = artist
    this.copyrightId = copyrightId
    this.name = name
    this.id = id
    this.picId = picId
    this.mark = mark
    this.status = status
    this.picUrl = picUrl
  }

}