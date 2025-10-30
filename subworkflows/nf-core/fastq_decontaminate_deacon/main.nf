include { DEACON_INDEX  } from '../../../modules/nf-core/deacon/index/main'
include { DEACON_FILTER } from '../../../modules/nf-core/deacon/filter/main'

workflow FASTQ_DECONTAMINATE_DEACON {

    take:
    ch_fasta_reads // [ val(meta), [ fasta ], [ reads ] ]

    main:

    ch_versions = Channel.empty()

    ch_fasta = ch_fasta_reads
        .map  { meta, fasta, reads -> [ meta, fasta ] }
    // Check if fastqs are single-end or paired-end and run Deacon accordingly
    ch_reads = ch_fasta_reads
        .map  { meta, fasta, reads ->
            if (meta.single_end) {
                if (reads instanceof List && reads.size() != 1) {
                    error("Error: Check your meta.single_end value. Single-end reads should contain one file only.")
                }
                return [ meta, reads ]
            } else {
                if (!(reads instanceof List) || reads.size() != 2) {
                    error("Error: Check your meta.single_end value. Paired-end reads should contain two files; a forward and a reverse.")
                }
                return [ meta, reads ]
            }
        }

    DEACON_INDEX ( ch_fasta )
    ch_versions = ch_versions.mix(DEACON_INDEX.out.versions.first())

    DEACON_FILTER(DEACON_INDEX.out.index.join(ch_reads))
    ch_versions = ch_versions.mix(DEACON_FILTER.out.versions.first())

    emit:
    index          = DEACON_INDEX.out.index           // channel: [ val(meta), [ index ] ]
    fastq_filtered = DEACON_FILTER.out.fastq_filtered // channel: [ val(meta), [ fastq ] ]
    summary        = DEACON_FILTER.out.log            // channel: [ val(meta), [ log ] ]

    versions = ch_versions                            // channel: [ versions.yml ]
}
