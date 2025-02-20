mol delete all
##******************
##Remember to change name of psf file
mol new ../protein_silica_solvated_0M.psf
mol addfile ../run3/nvt1.dcd waitfor all
mol addfile ../run3/nvt2.dcd waitfor all
mol addfile ../run3/nvt3.dcd waitfor all
mol addfile ../run3/nvt4.dcd waitfor all
mol addfile ../run3/nvt5.dcd waitfor all
mol addfile ../run3/nvt6.dcd waitfor all
set nframes [molinfo top get numframes]
puts "*********************************"
puts "Total number of frames is ${nframes}"
puts "*********************************"

 ##Fitting the protin molecule
set frame01 [atomselect top "chain G and protein and backbone" frame 0]
set frame0 [atomselect top "chain G and protein and name CA" frame 0]
for {set ix 1 } {$ix < $nframes } { incr ix } {
		set selx [atomselect top "chain G and protein and name CA" frame $ix]
		set all [atomselect top all frame $ix]
		$all move [measure fit $selx $frame0]
	}

 ######################################################
set sel [atomselect top "protein and chain G and resid 35 52"]
#**Specifying file names to store data
set outfile2 [open "sasa_Glu35_Asp52_3.dat" w]
#**
##**Calculation of waters, sasa, rog,rmsd

for {set i 0} {$i < $nframes} {incr i} {
		$sel frame $i
		$sel update
	        set sasa [measure sasa 1.4 $sel]
		puts $outfile2 [format "%d %2.2f" $i $sasa]
		}


close $outfile2
mol delete all
puts "This script calculated SASA for residues"
puts "GREAT!! IT IS ALL-DONE"
exit
