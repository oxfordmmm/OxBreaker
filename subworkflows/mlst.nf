include { FIND_MLST; FIND_wgMLST } from '../modules/assembly_utils.nf'
// Cannot call a process more than once, rename to re-use
include {FIND_MLST as FIND_MLST_REF} from '../modules/assembly_utils.nf'



// MAIN WORKFLOW
workflow MLST {
	take:
		consensus
		ref_genome

	main:
		if ( "$params.whole_genome" == true) {
			MLST = FIND_MLST(consensus, "$params.output/mlst/wg")
			// Whole-Genome MLST (wgMLST) - NOTE: Requires a reference genome in the DB
			wgMLST = FIND_wgMLST(consensus.collect(),
					     "$params.output/assembly/de_novo",
					     ref_genome,
					     "$params.output/mlst/wg/wgmlst")
			
		} else {
			MLST = FIND_MLST(consensus,
					 "$params.output/mlst")

			// Whole-Genome MLST (wgMLST) - NOTE: Requires a reference genome in the DB
			//wgMLST = FIND_wgMLST(consensus.collect(), "$params.output/assembly/consensus",
			//					 ref_genome, "$params.output/mlst/wgmlst")
		}

		// wgMLST.msa.collect()
		// wgMLST.msa_wo_controls.collect()
		MLST.mlst.collect()
							
	emit:
		classic = MLST.mlst
		//wgMLST_msa = wgMLST.msa
		//wgMLST_msa_wo_controls = wgMLST.msa_wo_controls
}
