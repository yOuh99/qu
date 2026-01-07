export class User{
  nickname: string
  userId:number
  userType:number
  avatarUrl: string
  authStatus:number

  constructor(nickname: string, userId: number, userType: number, avatarUrl: string, authStatus: number) {
    this.nickname = nickname
    this.userId = userId
    this.userType = userType
    this.avatarUrl = avatarUrl
    this.authStatus = authStatus
  }
}