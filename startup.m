% Project startup for Learning_PEMFC_IoT_ML.

proj = matlab.project.currentProject;
projectRoot = string(proj.RootFolder);

projectPath = genpath(projectRoot);
pathFolders = string(strsplit(projectPath, pathsep));
pathFolders(pathFolders == "") = [];

% Do not add source-control internals to the MATLAB path.
gitFolder = projectRoot + filesep + ".git";
pathFolders(startsWith(pathFolders, gitFolder)) = [];

addpath(strjoin(pathFolders, pathsep));

open(fullfile(projectRoot, "MainMenu.m"));
