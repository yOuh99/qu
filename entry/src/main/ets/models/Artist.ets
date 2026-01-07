export class Artist{
  img1v1Url:string
  musicSize:number
  albumSize:number
  img1v1:number
  name:string
  alias:string[]
  id:number
  picId:number

  constructor(img1v1Url: string, musicSize: number, albumSize: number, img1v1: number, name: string, alias: string[],
    id: number, picId: number) {
    this.img1v1Url = img1v1Url
    this.musicSize = musicSize
    this.albumSize = albumSize
    this.img1v1 = img1v1
    this.name = name
    this.alias = alias
    this.id = id
    this.picId = picId
  }



}