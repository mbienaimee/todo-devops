import js from "@eslint/js";
import react from "eslint-plugin-react";
import vitest from "eslint-plugin-vitest";

export default [
  js.configs.recommended,
  {
    files: ["src/**/*.{js,jsx}"],
    plugins: {
      react,
      vitest,
    },
    languageOptions: {
      globals: {
        ...vitest.environments.env.globals,
      },
    },
    rules: {
      "react/prop-types": "off",
      indent: ["error", 2],
      quotes: ["error", "single"],
      semi: ["error", "always"],
    },
  },
  {
    files: ["src/tests/**/*.{js,jsx}"],
    plugins: {
      vitest,
    },
    rules: {
      ...vitest.configs.recommended.rules,
    },
  },
];
