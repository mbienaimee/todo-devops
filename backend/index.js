import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import taskRouter from "./routes/taskRouter.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;
const MONGODB_URI =
  process.env.MONGODB_URI || "mongodb://localhost:27017/taskdb";

app.use(express.json());
app.use("/api/tasks", taskRouter);

// Only connect to MongoDB and start server if not in test mode
if (process.env.NODE_ENV !== "test") {
  mongoose
    .connect(MONGODB_URI)
    .then(() => console.log("Connected to MongoDB"))
    .catch((err) => console.error("MongoDB connection error:", err));

  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });
}

export default app;
