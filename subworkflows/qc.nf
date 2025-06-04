include { QC_ONT; FILTER_READS } from '../modules/assembly_utils.nf'
include { PLOT_QC } from '../modules/plot_figures.nf'
// Cannot call a process more than once, rename to re-use
include {QC_ONT as FILTERED_QC_ONT} from '../modules/assembly_utils.nf'



// MAIN WORKFLOW
workflow quality_control{
	// Function
	take:
		reads
		coverage
		Qthres

	main:
		// NO FILTERING
		//filtered = FILTER_READS(reads, Qthres, "$params.output/reads_merged/filtered")
		//control_filtered = FILTERED_QC_ONT(filtered.reads,
		//				     "$params.output/qc/filtered")

		control = QC_ONT(reads,
				 "$params.output/qc")

		PLOT_QC("$params.output/qc",
			control.qc.collect(),
			coverage.collect(),
			"$params.output/qc")
}
