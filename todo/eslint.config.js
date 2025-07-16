import js from "@eslint/js";
import reactPlugin from "eslint-plugin-react";
import jest from "eslint-plugin-jest";

export default [
  js.configs.recommended,
  {
    files: ["**/*.jsx", "**/*.js"],
    plugins: {
      react: reactPlugin,
      jest,
    },
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: "module",
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
      globals: {
        browser: true,
        es2021: true,
        window: true,
        document: true,
        localStorage: true,
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
      "react/react-in-jsx-scope": "off", // Disable react-in-jsx-scope for Vite/React 18
    },
  },
  {
    files: ["src/__tests__/**/*.jsx", "src/__tests__/**/*.js"],
    plugins: {
      jest,
    },
    languageOptions: {
      globals: {
        jest: true,
        describe: true,
        test: true,
        expect: true,
        beforeEach: true,
        afterEach: true,
        beforeAll: true,
        afterAll: true,
        window: true,
        document: true,
        localStorage: true,
      },
    },
    rules: {
      ...jest.configs.recommended.rules,
    },
  },
];
