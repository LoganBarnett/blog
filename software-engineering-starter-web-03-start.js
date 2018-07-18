const express = require('express')
const app = express()

app.get('/', (req, res) => {
  if(req.accepts('text/html')) {
    res.set('Content-Type', 'text/html')
    res.send('\
     <html>\
       <body>\
         Welcome to the official site for <em>justified</em>\
         <strong>cat hatred</strong>.\
       </body>\
     </html>')
  } else {
    res.set('Content-Type', 'text/plain')
    res.send('ohai')
  }
})

app.listen(3000, () => console.log('Example app listening on port 3000!'))
