const request = require("supertest");
const { MongoMemoryServer } = require("mongodb-memory-server");
const mongoose = require("mongoose");
const app = require("../src/app");
const Task = require("../src/models/Task");

let mongoServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = mongoServer.getUri();
  await mongoose.connect(mongoUri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
});

afterAll(async () => {
  await mongoose.connection.close();
  await mongoServer.stop();
});

afterEach(async () => {
  await Task.deleteMany();
});

describe("Task API", () => {
  it("should create a new task", async () => {
    const res = await request(app)
      .post("/api/tasks")
      .send({ title: "Test Task", description: "Test Description" });
    expect(res.statusCode).toBe(201);
    expect(res.body.title).toBe("Test Task");
    expect(res.body.status).toBe("active");
  });

  it("should get all tasks", async () => {
    await Task.create({ title: "Task 1", status: "active" });
    const res = await request(app).get("/api/tasks");
    expect(res.statusCode).toBe(200);
    expect(res.body.length).toBe(1);
    expect(res.body[0].title).toBe("Task 1");
  });

  it("should update task status", async () => {
    const task = await Task.create({ title: "Task 1", status: "active" });
    const res = await request(app)
      .put(`/api/tasks/${task._id}`)
      .send({ status: "completed" });
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe("completed");
  });

  it("should delete a task", async () => {
    const task = await Task.create({ title: "Task 1", status: "active" });
    const res = await request(app).delete(`/api/tasks/${task._id}`);
    expect(res.statusCode).toBe(200);
    expect(res.body.message).toBe("Task deleted");
  });
});
