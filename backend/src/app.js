const express = require("express");
const dotenv = require("dotenv");
const mongoose = require("mongoose");
const taskRoutes = require("./routes/taskRoutes");

dotenv.config();
const app = express();
app.use(express.json());

mongoose
  .connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error("MongoDB connection error:", err));

app.use("/api/tasks", taskRoutes);

module.exports = app;
