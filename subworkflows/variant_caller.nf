include { VARIANT_CALL_CLAIR3; VARIANT_CALL_LONGSHOT } from '../modules/assembly.nf'
include { GENERATE_CONSENSUS } from '../modules/phylogeny.nf'



// MAIN WORKFLOW
workflow variant_caller {
	// Input
	take:
		asmbl
		ref_genome
		depth
		depth_asmbl
		AFthres

	// Main
	main:
		variants = VARIANT_CALL_CLAIR3(asmbl.join(depth_asmbl),
					       AFthres, 
					       ref_genome,
					       "$params.output/vcf")
		//variants = VARIANT_CALL_LONGSHOT(asmbl.join(depth_asmbl),
		//				 AFthres,
		//				 ref_genome,
		//				 "$params.output/vcf")

		consensus = GENERATE_CONSENSUS(variants.vcf.join(depth).join(depth_asmbl),
					       asmbl.map{it -> it[1]}, ref_genome,
					       "$params.output/assembly/consensus")

	// Output
	emit:
		variants = variants.vcf
		consensus = consensus.fa
}
