import supertest from "supertest";
import mongoose from "mongoose";
import { MongoMemoryServer } from "mongodb-memory-server";
import app from "../index.js";

// Debug log to verify supertest loading
console.log(
  "Supertest loaded:",
  typeof supertest === "function" ? "Success" : "Failed"
);

let mongoServer;

// Connect to an in-memory MongoDB instance before tests
beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const uri = mongoServer.getUri();
  console.log("MongoDB URI:", uri); // Debug MongoDB URI
  await mongoose.connect(uri);
});

// Clear database after each test
afterEach(async () => {
  const collections = mongoose.connection.collections;
  for (const key in collections) {
    await collections[key].deleteMany({});
  }
});

// Stop MongoDB and close connection after all tests
afterAll(async () => {
  await mongoose.connection.close();
  await mongoServer.stop();
});

describe("Task API", () => {
  test("POST /api/tasks creates a new task", async () => {
    const response = await supertest(app)
      .post("/api/tasks")
      .send({ title: "Test Task", description: "Test Description" });
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty("_id");
    expect(response.body.title).toBe("Test Task");
    expect(response.body.description).toBe("Test Description");
    expect(response.body.createdAt).toBeDefined();
  });

  test("GET /api/tasks returns all tasks", async () => {
    await supertest(app).post("/api/tasks").send({ title: "Task 1" });
    const response = await supertest(app).get("/api/tasks");
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
    expect(response.body.length).toBe(1);
    expect(response.body[0].title).toBe("Task 1");
  });

  test("GET /api/tasks/:id returns a task by ID", async () => {
    const createResponse = await supertest(app)
      .post("/api/tasks")
      .send({ title: "Task to Get" });
    const taskId = createResponse.body._id;
    const response = await supertest(app).get(`/api/tasks/${taskId}`);
    expect(response.status).toBe(200);
    expect(response.body._id).toBe(taskId);
    expect(response.body.title).toBe("Task to Get");
  });

  test("PUT /api/tasks/:id updates a task", async () => {
    const createResponse = await supertest(app)
      .post("/api/tasks")
      .send({ title: "Task to Update" });
    const taskId = createResponse.body._id;
    const response = await supertest(app)
      .put(`/api/tasks/${taskId}`)
      .send({ title: "Updated Task", description: "Updated Description" });
    expect(response.status).toBe(200);
    expect(response.body._id).toBe(taskId);
    expect(response.body.title).toBe("Updated Task");
    expect(response.body.description).toBe("Updated Description");
  });

  test("DELETE /api/tasks/:id deletes a task", async () => {
    const createResponse = await supertest(app)
      .post("/api/tasks")
      .send({ title: "Task to Delete" });
    const taskId = createResponse.body._id;
    const response = await supertest(app).delete(`/api/tasks/${taskId}`);
    expect(response.status).toBe(204);
    const getResponse = await supertest(app).get(`/api/tasks/${taskId}`);
    expect(getResponse.status).toBe(404);
  });

  test("GET /api/tasks/:id returns 404 for non-existent task", async () => {
    const nonExistentId = new mongoose.Types.ObjectId();
    const response = await supertest(app).get(`/api/tasks/${nonExistentId}`);
    expect(response.status).toBe(404);
    expect(response.body.error).toBe("Task not found");
  });

  test("POST /api/tasks returns 400 for missing title", async () => {
    const response = await supertest(app)
      .post("/api/tasks")
      .send({ description: "No Title" });
    expect(response.status).toBe(400);
    expect(response.body.error).toBe("Title is required");
  });

  test("PUT /api/tasks/:id returns 400 for missing title", async () => {
    const createResponse = await supertest(app)
      .post("/api/tasks")
      .send({ title: "Task to Update" });
    const taskId = createResponse.body._id;
    const response = await supertest(app)
      .put(`/api/tasks/${taskId}`)
      .send({ description: "No Title" });
    expect(response.status).toBe(400);
    expect(response.body.error).toBe("Title is required");
  });

  test("PUT /api/tasks/:id returns 404 for non-existent task", async () => {
    const nonExistentId = new mongoose.Types.ObjectId();
    const response = await supertest(app)
      .put(`/api/tasks/${nonExistentId}`)
      .send({ title: "Updated Task" });
    expect(response.status).toBe(404);
    expect(response.body.error).toBe("Task not found");
  });

  test("DELETE /api/tasks/:id returns 404 for non-existent task", async () => {
    const nonExistentId = new mongoose.Types.ObjectId();
    const response = await supertest(app).delete(`/api/tasks/${nonExistentId}`);
    expect(response.status).toBe(404);
    expect(response.body.error).toBe("Task not found");
  });
});
