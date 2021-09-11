process.stdout.write("T   R   ⚫  Ͷ\n");

// const cp = require('child_process');
// const fs = require('fs');
// var cwd = process.cwd();

let project = new Project('tron');
project.addSources('Sources');
// project.addParameter('-main tron.App');
// project.addDefine("source-header=TR0N");
// project.addShaders('Shaders/**');
//project.addAssets('Assets/font/**', { notinlist: false });
// project.addParameter('--macro tron.Build.application()');
resolve(project);
