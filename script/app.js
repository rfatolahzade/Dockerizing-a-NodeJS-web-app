var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
var usersRouter = require("./routes/users");
var app = express();


app.get("/Exception", function mainHandler(req, res) {
    throw new Error("An exception occured!");
});

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));


app.use("/users", usersRouter);
app.get("/Hello", function rootHandler(req, res) {
    res.end("Hello world!!");
});

app.use("/POW", function (req, res, next) {
    res.send(Math.pow(req.query.a, req.query.b).toString());
});

var listener = app.listen(8080, function () {
    console.log("Listening on port " + listener.address().port);
});
