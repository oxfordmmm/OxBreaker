include { ASSEMBLE_ONT; MAP_REFERENCE } from '../modules/assembly.nf'
include { CALCULATE_COVERAGE_DEPTH;  GENERATE_BED } from '../modules/assembly_utils.nf'
include { PLOT_COVERAGE } from '../modules/plot_figures.nf'



//WORKFLOW: MAP TO REFERENCE GENOME
workflow reference_mapping {
	take:
		reads
		ref_genome

	main:
		bed = GENERATE_BED(ref_genome,
				   "$params.output/assembly")

		mapped_asmbl = MAP_REFERENCE(reads,
					     ref_genome,
					     bed.file,
					     "$params.output/assembly")

		barcode_depth = CALCULATE_COVERAGE_DEPTH(mapped_asmbl.bam,
							 "$params.output/depth")

		PLOT_COVERAGE("$params.output/depth",
			      barcode_depth.cov.collect(),
			      "$params.output/depth")

	emit:
		asmbl = mapped_asmbl.bam
		coverage = barcode_depth.cov
		depth = barcode_depth.tsv
		depth_asmbl = barcode_depth.depth
}


// WORKFLOW: DE NOVO ASSEMBLY
workflow denovo_assembly{
	take:
		reads

	main:
		denovo = ASSEMBLE_ONT(reads, "$params.output/assembly/de_novo")

		asmbl = denovo.assembly.map { it -> it[1] }  // Get rid of 'barcode'

		// Compute depth using de novo assembly as reference
		mapped = reference_mapping(reads, asmbl)
    
	emit:
		asmbl = denovo.assembly
		coverage = mapped.coverage
		depth = mapped.depth
		depth_asmbl = mapped.depth_asmbl
}
