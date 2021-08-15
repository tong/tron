// const cp = require('child_process');
process.stdout.write("   |  |  |   T   R   ⚫  Ͷ\n");

const fs = require('fs');

let project = new Project('tron');

project.addSources('Sources');
//project.addShaders('Shaders/**');
//project.addAssets('Assets/font/**', { notinlist: false });

// var cwd = process.cwd();

resolve(project);
