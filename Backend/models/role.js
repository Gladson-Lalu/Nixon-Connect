const { Schema, Types, model } = require('mongoose');

//create role schema
const roleSchema = new Schema({
    roleName: {
        type: String,
        required: true,
        default: 'member',
    },
    userPermissions: [{ type: Types.ObjectId, ref: 'Permission' }],
    room: { type: Types.ObjectId, ref: 'Room' },
});

const Role = model('Role', roleSchema);

module.export = Role;