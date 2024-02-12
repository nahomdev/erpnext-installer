#!/usr/bin/env node
const { spawn } = require("child_process");
const path = require("path");
const fs = require("fs");

const scriptPath = path.join(__dirname, "installer.sh");

const setExecutePermissions = (filePath) => {
  try {
    fs.accessSync(filePath, fs.constants.F_OK);
    fs.chmodSync(filePath, 0o755);
    console.log(`Execute permissions set for ${filePath}`);
  } catch (error) {
    console.error(
      `Error setting execute permissions for ${filePath}:`,
      error.message
    );
  }
};

setExecutePermissions(scriptPath);

const child = spawn("bash", [scriptPath], { stdio: "inherit" });

child.on("exit", (code) => {
  if (code === 0) {
    console.log("Script execution completed successfully.");
  } else {
    console.error(`Script execution failed with code ${code}.`);
  }
});
