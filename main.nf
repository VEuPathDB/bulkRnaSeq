#!/usr/bin/env nextflow

//---------------------------------------
// include the RNA seq workflow
//---------------------------------------

include { ran_seq } from  './RNA_Seq_Nextflow.nf'


//--------------------------------------
// Process the workflow
//-------------------------------------

workflow RNA_Seq_Nextflow {
    if (!params.reads) {
        throw new Exception("Missing parameter params.reads")
    }
    
    if (!params.reference) {
        throw new Exception("Missing parameter params.reference")
    }
     if (!params.annotation) {
        throw new Exception("Missing parameter params.annotation")
    }

    if (!params.fastqcExtension) {
        throw new Exception("Missing parameter params.fastqcExtension")
    }


    reads_qc = Channel.fromPath("${params.reads}/*", checkIfExists: true) 

// read_ch for trimming and mapping generated based on weather the sequencing is single or paired end.
    if (params.isPaired){
        reads_ch = Channel.fromFilePairs([params.reads + '/*_{1,2}.fastq', params.reads + '/*_{1,2}.fastq.gz', params.reads + '/*_{1,2}.fq.gz'])
    } else {
        reads_ch = Channel.fromPath([params.reads + '/*.fastq', params.reads + '/*.fastq.gz', params.reads + '/*.fq.gz'])

}
    rna_seq(reads_qc, reads_ch)
}