process SPECIES_PROFILING_ONT {
	label "kraken2"
	tag { "Autodetecting reference using sample $sample" }

	publishDir "$outdir", overwrite: true, mode: 'copy'
	cpus = 4

	input:
	tuple val(sample), path(reads)
	val(outdir)
	val(results)

	output:
	tuple val(sample), path("${sample}.kraken.report"), emit: report

	script:
	"""
		kraken2 -db $params.db --report ${sample}.kraken.report \
			--output - \
			--threads $task.cpus --memory-mapping \
			$reads
	"""

	stub:
	"""
		touch ${sample}.kraken.report
	"""
}


process DOWNLOAD_FASTA {
	label "kraken2"
	tag { "Downloading reference genome " }

	publishDir "$outdir", overwrite: true, mode: 'copy'
	cpus = 1
	
	input:
	tuple val(filename), path(kraken2_report)
	val(outdir)

	output:
	tuple val("reference"), path("reference.fa"), emit: genome

	script:
	"""
		python3 $params.bin/download_reference.py $kraken2_report

		# Unzip
		gunzip reference.fna.gz

		# Rename
		mv reference.fna reference.fa
	"""

	stub:
	"""
		touch reference.fa
	"""
}
