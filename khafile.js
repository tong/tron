process.stdout.write("   T   R   ⚫  Ͷ\n");

// const cp = require('child_process');
const fs = require('fs');

let project = new Project('tron');
project.addSources('Sources');
//project.addShaders('Shaders/**');
//project.addAssets('Assets/font/**', { notinlist: false });
// var cwd = process.cwd();
// project.addParameter('--macro tron.Build.application()');
resolve(project);
