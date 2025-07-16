import { render, screen, fireEvent, cleanup } from "@testing-library/react";
import TodoApp from "../components/TodoApp";

beforeEach(() => {
  localStorage.clear();
  cleanup();
});

describe("TodoApp", () => {
  test("renders TodoApp component", () => {
    render(<TodoApp />);
    expect(screen.getByText("To-Do List")).toBeInTheDocument();
    expect(
      screen.getByPlaceholderText("Add a new task...")
    ).toBeInTheDocument();
  });

  test("adds a new todo", () => {
    render(<TodoApp />);
    const input = screen.getByPlaceholderText("Add a new task...");
    const addButton = screen.getByText("Add");
    fireEvent.change(input, { target: { value: "Test Todo" } });
    fireEvent.click(addButton);
    expect(screen.getByText("Test Todo")).toBeInTheDocument();
  });

  test("toggles todo completion", () => {
    render(<TodoApp />);
    const input = screen.getByPlaceholderText("Add a new task...");
    const addButton = screen.getByText("Add");
    fireEvent.change(input, { target: { value: "Test Todo" } });
    fireEvent.click(addButton);
    const checkbox = screen.getByRole("checkbox");
    fireEvent.click(checkbox);
    const todoText = screen.getByText("Test Todo");
    expect(todoText).toHaveClass("line-through");
  });

  test("deletes a todo", () => {
    render(<TodoApp />);
    const input = screen.getByPlaceholderText("Add a new task...");
    const addButton = screen.getByText("Add");
    fireEvent.change(input, { target: { value: "Test Todo" } });
    fireEvent.click(addButton);
    const deleteButton = screen.getByText("Delete");
    fireEvent.click(deleteButton);
    expect(screen.queryByText("Test Todo")).not.toBeInTheDocument();
  });

  test("persists todos in localStorage", () => {
    render(<TodoApp />);
    const input = screen.getByPlaceholderText("Add a new task...");
    const addButton = screen.getByText("Add");
    fireEvent.change(input, { target: { value: "Test Todo" } });
    fireEvent.click(addButton);
    cleanup();
    render(<TodoApp />);
    expect(screen.getByText("Test Todo")).toBeInTheDocument();
  });
});
