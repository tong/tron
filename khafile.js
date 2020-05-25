var project = new Project('Tron');
project.addDefine('tron');
//project.addAssets('Assets/font/**', { notinlist: false });
//project.addShaders('Shaders/**');
project.addSources('Sources');
resolve(project);
