class ActiveUserInfo {
    constructor(userId, socket, location = { latitude: 0, longitude: 0 }) {
        this.userId = userId;
        this.socket = socket;
        this.location = {
            latitude: location.latitude,
            longitude: location.longitude,
        }
    }
}

module.exports.ActiveUserInfo = ActiveUserInfo;