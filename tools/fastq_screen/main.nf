nextflow.preview.dsl=2

process FASTQ_SCREEN {
	
	// depending on the number of genomes and the type of genome (e.g. plants!), memory needs to be ample!
	// label 'bigMem'
	// label 'multiCore'

    input:
	    tuple val(name), path(reads)
		val (outputdir)
		val (fastq_screen_args)
		val (verbose)

	output:
	    path "*png",  emit: png
	    path "*html", emit: html
		path "*txt",  emit: report

	publishDir "$outputdir",
		mode: "link", overwrite: true

    script:
		fastq_screen_args = fastq_screen_args.replaceAll(/'/,"")

		if (verbose){
			println ("[MODULE] FASTQ SCREEN ARGS: "+ fastq_screen_args)
		}

	"""
	module load fastq_screen
	fastq_screen $fastq_screen_args $reads
	"""

}