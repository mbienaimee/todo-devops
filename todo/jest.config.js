export default {
  testEnvironment: "jsdom",
  setupFilesAfterEnv: ["<rootDir>/src/__tests__/setupTests.js"],
  transform: {
    "^.+\\.(js|jsx)$": "babel-jest",
  },
  moduleFileExtensions: ["js", "jsx"],
  extensionsToTreatAsEsm: [".jsx"],
  testMatch: ["<rootDir>/src/__tests__/**/*.test.{js,jsx}"],
  testPathIgnorePatterns: ["<rootDir>/src/__tests__/setupTests.js"],
};
