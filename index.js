#!/usr/bin/env node
const { spawn } = require("child_process");
const path = require("path");

const scriptPath = path.join(__dirname, "installer.sh");

const child = spawn("bash", [scriptPath], { stdio: "inherit" });

child.on("exit", (code) => {
  if (code === 0) {
    console.log("Script execution completed successfully.");
  } else {
    console.error(`Script execution failed with code ${code}.`);
  }
});
