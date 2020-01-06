# Teresa Tang (tangsteresa@gmail.com)
# Last update: 1/11/2019 
# Purpose: To plot vectors representing the path of a toy car based only on 
# its numerical speed and absolute orientation in the XY plane (degrees)

#////////////////////////////////////////////////////////////////////////////

# specify the file of interest below
fileName = 'datalogtest .CSV'; 

printf(["\nOpening file " fileName "..."]); 

# find num lines in file 
file = fopen(fileName, "r"); 
nlines = fskipl (file, Inf); 
fclose(file);

# read timestamps in ms from file 
timestamp = dlmread(fileName, ',', [1, 3, nlines, 3]); 
traj_times = []; 

printf("\nFinding trajectories..."); 

for value = 2: (nlines-1)
  # finds indexes for the endpoints of the trajectories
  # if the difference in ms timestamps is greater than 2 then 
  # must be new trajectory 
  if (timestamp(value) - timestamp(value-1)) > 2
    traj_times = [traj_times, (value-1)]; 
  endif
endfor

# mark the last point in the file as an endpoint
traj_times = [traj_times, nlines-1]; 

# get number of trajectories 
num_traj = size(traj_times) (2)

# note that column/row indices start at 0 
# start at row 2 to skip string headers 
# euler X angles are at column 6
yawAngle = dlmread(fileName, ',', [1, 6, nlines, 6]);

# indices for matrix start at 1 
# speed values are in column 5
speed = dlmread(fileName, ',', [1, 5, nlines, 5]); 

# remove .CSV from name of file 
fileName = strrep(fileName, ".CSV", ""); 

# start at first trajectory 
traj = 1; 

# index of trajectory startpoint 
traj_start = 1; 

# index of trajectory endpoint
traj_end = traj_times(traj); 

while (traj < (num_traj + 1)) 
  x0 = 0;
  y0 = 0; 
  
  printf(["\nPlotting trajectory " num2str(traj)]);
  
  # create figure that doesn't display
  figure(traj); 
  title(["Vector Path of GBG Toy Car Trajectory " num2str(traj)]);
  #title("Vector Path of GBG Toy Car")
  xlabel('X');
  ylabel('Y');
  axis equal square;

  # plot all arrows on the same graph 
  hold on;
  for value = traj_start: traj_end
    x = speed(value) * cosd(yawAngle(value));
    y = speed(value) * sind(yawAngle(value)); 
    quiver(x0, y0, x, y, scale = 0); 
    x0 = x + x0;
    y0 = y + y0;
    pause(0.1);
  endfor
  hold off;

  # create name to save plot as 
  pathName = [fileName "Traj" num2str(traj) ".jpg"]; 

  # save file
  saveas(gca, pathName, 'jpg'); 
  
  # iterate to next trajectory 
  traj = traj + 1; 
  traj_start = traj_end + 1;
  #traj_end = traj_times(traj); 
  
  # prevents out of bound array index error 
  if traj != (num_traj + 1)
    traj_end = traj_times(traj); 
  endif 
  
endwhile 

printf("\nData analysis complete"); 
