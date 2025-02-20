set output_TM [open "Protein_TM_angle.dat" w]
###########################
mol new ../protein_silica_solvated_0M.psf
mol addfile ../protein_silica_solvated_0M.pdb
mol addfile ../nvt1.dcd waitfor all
mol addfile ../nvt2.dcd waitfor all

set numframes [molinfo top get numframes]
##########CALCULATE Angle of TM helix of Protein #########################################
for {set frame 0} {$frame < $numframes} {incr frame} {

set p_TM1 [atomselect top "protein and resid 1 and name CA" frame $frame]
set c_TM1 [measure center $p_TM1 weight mass]
set p_TM2 [atomselect top "protein and resid 20 and name CA" frame $frame]
set c_TM2 [measure center $p_TM2 weight mass]

set ax_TM [vecsub $c_TM2 $c_TM1]
set lax_TM [veclength $ax_TM]
set k "0 0 1"

set dot_TM [vecdot $ax_TM $k]
set cos_TM [expr "$dot_TM / $lax_TM"]

set ang_rad_TM [tcl::mathfunc::acos "$cos_TM"]
set ang_deg_TM [expr "57.2957795 * $ang_rad_TM"]

puts $output_TM "$frame $ang_deg_TM"
puts "$frame $ang_deg_TM"

$p_TM1 delete
$p_TM2 delete
}
quit
