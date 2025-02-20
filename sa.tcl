mol delete all
##******************
##Remember to change name of psf file
mol new ../protein_silica_solvated_0M.psf
mol addfile ../run1/nvt1.dcd waitfor all
#mol addfile ../run5/nvt5.dcd waitfor all
#mol addfile ../run5/nvt6.dcd waitfor all
#mol addfile ../nvt2.dcd waitfor all
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
set sel [atomselect top "protein and chain G"]
set waters [atomselect top "(protein and chain G) and (pbwithin 10 of chain A)"]
#**Specifying file names to store data
set outfile2 [open "sasa_1.dat" w]
set outfile3 [open "radius_of_gyration_1.dat" w]
set outfile4 [open "rmsd_1.dat" w]
set outfile5 [open "hbonds_pnp_1.dat" w]
set outfile6 [open "rmsf_1.dat" w]
set outfile7 [open "hbonds_pnw_1.dat" w]
#**
##**Calculation of waters, sasa, rog,rmsd

for {set i 0} {$i < $nframes} {incr i} {
		$sel frame $i
		$sel update
	        set sasa [measure sasa 1.4 $sel]
		set rog [measure rgyr $sel]
		set selrms [atomselect top "protein and backbone and chain G" frame $i]
		set rms [measure rmsd $selrms $frame01]
		puts $outfile2 [format "%d %2.2f" $i $sasa]
		puts $outfile3 [format "%d %2.2f" $i $rog]
		puts $outfile4 [format "%d %2.2f" $i $rms]

	}

	##**Calculation of h-bonds between peptide
	set D [atomselect top "protein and chain G"]
	for {set j 0} {$j < $nframes} {incr j} {
			$D frame $j
			$D update
			set hbondList [measure hbonds 4.0 30 $D]
			set hbondNumber [llength [lindex $hbondList 0]]
			puts $outfile5 [format "%d %d" $j $hbondNumber]
		}

	##**Calculation of h-bonds between peptide and water
	set D1 [atomselect top "resname TIP3"]
	set A1 [atomselect top "protein and chain G"]
	set D2 [atomselect top "protein and chain G"]
	set A2 [atomselect top "resname TIP3"]
	for {set j 0} {$j < $nframes} {incr j} {
			$D1 frame $j
			$A1 frame $j
			$D2 frame $j
			$A2 frame $j
			$A1 update
			$D1 update
			$A2 update
			$D2 update
			set hbondList1 [measure hbonds 4.0 30 $D1 $A1]
			set hbondList2 [measure hbonds 4.0 30 $D2 $A2]
			set hbondNumber1 [llength [lindex $hbondList1 0]]
			set hbondNumber2 [llength [lindex $hbondList2 0]]
			set totalhbondpnw [expr $hbondNumber1 + $hbondNumber2]
			puts $outfile7 [format "%d %d" $j $totalhbondpnw]
		}

##**Calculation of RMSF
set sel1 [atomselect top "protein and chain G and name CA"]
 for {set k 0} {$k < [$sel1 num]} {incr k} {
 set rmsf [measure rmsf $sel1 ]
 puts $outfile6 "[expr {$k+1}] [lindex $rmsf $k]"
 }
close $outfile2
close $outfile3
close $outfile4
close $outfile5
close $outfile6
close $outfile7
mol delete all
puts "This script calculated SASA, waters within 10 A of protein, ROG, RMSD, RMSF and h-bonds"
puts "GREAT!! IT IS ALL-DONE"
exit
