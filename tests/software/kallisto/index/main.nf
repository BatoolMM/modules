#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { KALLISTO_INDEX } from '../../../../software/kallisto/index/main.nf' addParams( options: [:] )

workflow test_kallisto_index {
    
    def input = file("${launchDir}/tests/data/genomics/sarscov2/bam/test_single_end.bam", checkIfExists: true)

    KALLISTO_INDEX ( input )
}
