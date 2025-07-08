export default {
  testEnvironment: "jsdom",
  setupFilesAfterEnv: ["<rootDir>/src/__tests__/setupTests.js"],
  transform: {
    "^.+\\.(js|jsx)$": "babel-jest",
  },
  moduleFileExtensions: ["js", "jsx"],
  extensionsToTreatAsEsm: [".jsx"],
  testMatch: [
    "<rootDir>/src/__tests__/**/*.test.{js,jsx}", // Only .test.js and .test.jsx files
  ],
  testPathIgnorePatterns: [
    "<rootDir>/src/__tests__/setupTests.js", // Explicitly ignore setupTests.js
  ],
};
