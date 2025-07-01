import React from "react";
import { render, screen, fireEvent } from "@testing-library/react";
import TaskForm from "../components/TaskForm";

test("renders TaskForm and submits data", async () => {
  const onTaskAdded = jest.fn();
  render(<TaskForm onTaskAdded={onTaskAdded} />);

  fireEvent.change(screen.getByLabelText(/title/i), {
    target: { value: "Test Task" },
  });
  fireEvent.change(screen.getByLabelText(/description/i), {
    target: { value: "Test Description" },
  });
  fireEvent.click(screen.getByText(/add task/i));

  expect(onTaskAdded).toHaveBeenCalled();
});
