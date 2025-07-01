import React from "react";
import axios from "axios";

const TaskItem = ({ task, onTaskUpdated, onTaskDeleted }) => {
  const handleComplete = async () => {
    try {
      const res = await axios.put(
        `http://localhost:5000/api/tasks/${task._id}`,
        {
          status: task.status === "active" ? "completed" : "active",
        }
      );
      onTaskUpdated(res.data);
    } catch (err) {
      console.error(err);
    }
  };

  const handleDelete = async () => {
    try {
      await axios.delete(`http://localhost:5000/api/tasks/${task._id}`);
      onTaskDeleted(task._id);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="flex justify-between items-center p-4 bg-gray-100 rounded mb-2">
      <div>
        <h3 className={task.status === "completed" ? "line-through" : ""}>
          {task.title}
        </h3>
        <p>{task.description}</p>
      </div>
      <div>
        <button
          onClick={handleComplete}
          className="bg-green-500 text-white p-2 rounded mr-2 hover:bg-green-600"
        >
          {task.status === "active" ? "Complete" : "Undo"}
        </button>
        <button
          onClick={handleDelete}
          className="bg-red-500 text-white p-2 rounded hover:bg-red-600"
        >
          Delete
        </button>
      </div>
    </div>
  );
};

export default TaskItem;
