import React from "react";
import TaskItem from "./TaskItem";

const TaskList = ({ tasks, onTaskUpdated, onTaskDeleted }) => {
  return (
    <div className="max-w-2xl mx-auto mt-4">
      {tasks.map((task) => (
        <TaskItem
          key={task._id}
          task={task}
          onTaskUpdated={onTaskUpdated}
          onTaskDeleted={onTaskDeleted}
        />
      ))}
    </div>
  );
};

export default TaskList;
