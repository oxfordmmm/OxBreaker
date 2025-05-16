include { MERGE_BARCODES } from './modules/barcode_processing.nf'



// MAIN WORKFLOW
workflow preprocess_reads {
        data = Channel.from("$params.input")
        MERGE_BARCODES(data)
}
