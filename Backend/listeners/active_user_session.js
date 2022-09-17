class ActiveUserInfo {
    constructor(userId, socketId, location = { latitude: 0, longitude: 0 }) {
        this.userId = userId;
        this.socketId = socketId;
        this.location = {
            latitude: location.latitude,
            longitude: location.longitude,
        }
    }
}

module.exports.ActiveUserInfo = ActiveUserInfo;