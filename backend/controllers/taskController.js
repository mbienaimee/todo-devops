import * as taskModel from "../models/taskModel.js";

export const createTask = async (req, res) => {
  const { title, description } = req.body;
  if (!title) {
    return res.status(400).json({ error: "Title is required" });
  }
  try {
    const task = await taskModel.createTask(title, description);
    res.status(201).json(task);
  } catch (error) {
    res.status(500).json({ error: "Server error" });
  }
};

export const getAllTasks = async (req, res) => {
  try {
    const tasks = await taskModel.getAllTasks();
    res.json(tasks);
  } catch (error) {
    res.status(500).json({ error: "Server error" });
  }
};

export const getTaskById = async (req, res) => {
  try {
    const task = await taskModel.getTaskById(req.params.id);
    if (!task) {
      return res.status(404).json({ error: "Task not found" });
    }
    res.json(task);
  } catch (error) {
    res.status(500).json({ error: "Server error" });
  }
};

export const updateTask = async (req, res) => {
  const { title, description } = req.body;
  if (!title) {
    return res.status(400).json({ error: "Title is required" });
  }
  try {
    const task = await taskModel.updateTask(req.params.id, title, description);
    if (!task) {
      return res.status(404).json({ error: "Task not found" });
    }
    res.json(task);
  } catch (error) {
    res.status(500).json({ error: "Server error" });
  }
};

export const deleteTask = async (req, res) => {
  try {
    const success = await taskModel.deleteTask(req.params.id);
    if (!success) {
      return res.status(404).json({ error: "Task not found" });
    }
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: "Server error" });
  }
};
