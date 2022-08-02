const { mongoose } = require('mongoose');
const express = require('express');
require('dotenv').config({ path: 'config.env' });
const authRoutes = require('./routes/auth_routes');
const apiRoutes = require('./routes/api_routes');

const app = express();


app.use(express.json());
app.use(authRoutes);
app.use(apiRoutes);


app.get('*', (_, res) => {
    res.send('404');
});

//connect to mongoDB and start the server
mongoose.connect(process.env.MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => {
        console.log('connected to mongoDB');
        app.listen(process.env.PORT, () => {
            console.log(`server is listening on port ${process.env.PORT}`);
        }) //end of mongoose.connect
    })
    .catch(err => {
        console.log(err);
    }); 
