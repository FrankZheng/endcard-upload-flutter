var express = require("express");
var cors = require("cors");
var fileUpload = require("express-fileupload");
var app = express();
const port = 8091;

app.use(cors());
app.use(
  fileUpload({
    useTempFiles: true,
    tempFileDir: "./uploaded_files"
  })
);
app.use(express.static("web"));

app.get("/", function(req, res) {
  res.send("Hello World!");
});

app.post("/ok", function(req, res) {
  res.header("Content-Type", "application/json");
  res.send('{"code":0, "msg":"OK"}');
});

app.post("/upload", function(req, res) {
  console.log(req.files); // the uploaded file object
  res.header("Content-Type", "application/json");
  res.send('{"code":0, "msg":"OK"}');
});

app.listen(port, function() {
  console.log("Example app listening on port " + port + "!");
});
