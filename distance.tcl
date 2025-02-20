mol delete all
##******************
##Remember to change name of psf file
mol new ../protein_silica_solvated_0M.psf
mol addfile ../run1/nvt1.dcd waitfor all
#mol addfile ../run5/nvt2.dcd waitfor all
#mol addfile ../run5/nvt3.dcd waitfor all
#mol addfile ../run5/nvt4.dcd waitfor all
#mol addfile ../run5/nvt5.dcd waitfor all
#mol addfile ../run5/nvt6.dcd waitfor all
#mol addfile ../nvt2.dcd waitfor all
set nframes [molinfo top get numframes]
puts "*********************************"
puts "Total number of frames is ${nframes}"
puts "*********************************"

 set outfile1 [open "Distance_GLU35_ASP52_1.dat" w]
 set group1 [atomselect top "residue 35"]
 set group2 [atomselect top "residue 52"]

 for {set i 0} {$i < $nframes} {incr i} {
 $group1 frame $i
 $group2 frame $i
 $group1 update
 $group2 update
 set distance1 [veclength [vecsub [measure center $group1] [measure center $group2]]]
 puts $outfile1 [format "%d \t %2.2f " $i $distance1]
 }

close $outfile1
exit
