const sql = require("mssql");

var config = {
    user: 'sa',
    password: 'DESKTOP-7F7VPTU\MSSQLSERVER01',
    server: '127.0.0.1', 
    database: 'Users',
    options: {
        trustedConnection: true
    }
}

   


// connect to your database
sql.connect(config).then(()=>console.log('DB connection successfull')).catch((err)=>console.log(err))