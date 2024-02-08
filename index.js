#!/usr/bin/env node
const path = require("path");
const shell = require("shelljs");

shell.exec(path.join(__dirname, "/installer.sh"));
