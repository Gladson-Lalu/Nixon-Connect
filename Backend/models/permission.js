//create permissions enums
const { Schema, model } = require('mongoose');
const permissionSchema = new Schema({
    permissionName: {
        type: String,
        enum: ['add-host', 'view', 'add-reaction', 'send-message', 'kick-user', 'admin'],
        required: true,
        default: 'view',
    },
});
const Permission = model('Permission', permissionSchema);
module.exports = Permission;

