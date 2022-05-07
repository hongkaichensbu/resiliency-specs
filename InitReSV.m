function InitReSV()
% InitReSV  initializes ReSV, along with modified Breach

fprintf("Initializing ReSV...")
addpath("ReSV_quant")
addpath("ReSV_quant\Core")
addpath("ReSV_quant\Display\")
addpath("uav_example\")
addpath("uav_example\control")
addpath("uav_example\control\utils")
addpath("uav_example\control\trajectories\")
addpath("flocking_example\")
fprintf("Done.\n")

cd('breach')
InitBreach
cd('..')

end