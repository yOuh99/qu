import { User } from "./User"

export class Playlist{
  id:number
  name:string
  coverImgUrl:string
  creator:User[]
  subscribed:string
  trackCount:number
  userId:number
  playCount:number
  bookCount:number
  specialType:number
  officialTags:string[]


  constructor(id: number, name: string, coverImgUrl: string, creator: User[], subscribed: string, trackCount: number,
    userId: number, playCount: number, bookCount: number, specialType: number, officialTags: string[]) {
    this.id = id
    this.name = name
    this.coverImgUrl = coverImgUrl
    this.creator = creator
    this.subscribed = subscribed
    this.trackCount = trackCount
    this.userId = userId
    this.playCount = playCount
    this.bookCount = bookCount
    this.specialType = specialType
    this.officialTags = officialTags
  }

}