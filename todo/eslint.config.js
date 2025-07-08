import js from "@eslint/js";
import reactPlugin from "eslint-plugin-react";
import jestPlugin from "eslint-plugin-jest";

export default [
  {
    ignores: [
      "jest.config.js",
      "babel.config.js",
      "vite.config.js",
      "postcss.config.js",
      "tailwind.config.js",
    ],
  },
  {
    ...js.configs.recommended,
    files: ["**/*.js", "**/*.jsx"],
    plugins: {
      react: reactPlugin,
      jest: jestPlugin,
    },
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
      globals: {
        browser: "readonly",
        es2021: "readonly",
        window: "readonly",
        document: "readonly",
        localStorage: "writable",
      },
    },
    settings: {
      react: {
        version: "18.2",
      },
    },
    rules: {
      ...reactPlugin.configs.recommended.rules,
      "react/prop-types": "off",
      "react/react-in-jsx-scope": "off", // Not needed for React 18 with Vite
    },
  },
  {
    files: ["src/__tests__/**/*.js", "src/__tests__/**/*.jsx"],
    plugins: {
      jest: jestPlugin,
    },
    languageOptions: {
      globals: {
        jest: "readonly",
        describe: "readonly",
        test: "readonly",
        expect: "readonly",
        beforeEach: "readonly",
        afterEach: "readonly",
        beforeAll: "readonly",
        afterAll: "readonly",
        window: "readonly",
        document: "readonly",
        localStorage: "writable",
      },
    },
    rules: {
      ...jestPlugin.configs.recommended.rules,
      "jest/no-disabled-tests": "warn",
      "jest/no-focused-tests": "error",
      "jest/no-identical-title": "error",
      "jest/prefer-to-have-length": "warn",
      "jest/valid-expect": "error",
    },
  },
];
