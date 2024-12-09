export default {
  "env": {
    "browser": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended"
  ],
  "settings": {
    "react": {
      "version": "detect" // Automatically detects the version of React you are using
    }
  },
  "plugins": [
    "react"
  ],
  "rules": {
    // You can add custom ESLint rules here if needed
  }
};
