const { mongoose } = require('mongoose');
const express = require('express');
const http = require('http');
require('dotenv').config({ path: 'config.env' });
const authRoutes = require('./routes/auth_routes');
const apiRoutes = require('./routes/api_routes');
const roomRoutes = require('./routes/room_routes');
const { SocketIO } = require('./listeners/index');
const app = express();
const server = http.createServer(app);
const io = require('socket.io')(server,
    {
        cors: {
            origin: '*',
        }
    });

const _socketIo = new SocketIO();
_socketIo.Init(io);

app.use(express.json());
app.use(authRoutes);
app.use(apiRoutes);
app.use(roomRoutes);

app.get('*', (_, res) => {
    res.send('404');
});

//connect to mongoDB and start the server
mongoose.connect(process.env.MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => {
        console.log('connected to mongoDB');
        server.listen(process.env.PORT, () => {
            console.log(`server is listening on port ${process.env.PORT}`);
        }) //end of mongoose.connect
    })
    .catch(err => {
        console.log(err);
    }); 
