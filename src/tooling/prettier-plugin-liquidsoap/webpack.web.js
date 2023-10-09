const path = require("path");

module.exports = {
  entry: "./src/base.mjs",
  mode: "production",
  experiments: {
    outputModule: true,
  },
  output: {
    path: __dirname + "/dist",
    filename: "web.mjs",
    library: {
      type: "module",
    },
  },
};