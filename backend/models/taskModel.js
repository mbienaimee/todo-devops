import mongoose from "mongoose";

const taskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, default: "" },
  createdAt: { type: Date, default: Date.now },
});

const Task = mongoose.model("Task", taskSchema);

export const createTask = async (title, description) => {
  const task = new Task({ title, description });
  return await task.save();
};

export const getAllTasks = async () => {
  return await Task.find();
};

export const getTaskById = async (id) => {
  return await Task.findById(id);
};

export const updateTask = async (id, title, description) => {
  return await Task.findByIdAndUpdate(
    id,
    { title, description },
    { new: true, runValidators: true }
  );
};

export const deleteTask = async (id) => {
  const result = await Task.findByIdAndDelete(id);
  return !!result;
};
