# GFD analysis based on the results of vConTACT clustering



### vConTACT clustering
Scripts are in the __run_vcontact/__ folder:

* __1_prepare_vcontact_input_GFD.sh__ prepares FASTA file and a corresponding “genome-to-genome” file with proteins encoded by 41014 GFD contigs

* __2_prepare_vcontact_input_crAss249.sh__ prepares FASTA file and a corresponding “genome-to-genome” file with proteins encoded by 249 crAss-like phages collected by Guerin et al.

* __3_merge_vcontact_inputs.sh__ combines two FASTA files into one; two “genome-to-genome” files into one

* __4_run_vcontact.sh__ runs vConTACT



### Build VC-based read counts table
Scripts are in the __VC_counts_table/__ folder.
Script __build_VC_counts_table.sh__ launches __build_VC_counts_table.R__ that calls __function_aggregate_by_VC.R__.



### VC-based taxonomy assignment extension
Scripts are in the __VC_taxo_extension/__ folder.
Script __VC_taxo_extension.sh__ launches __VC_taxo_extension.R__.



### Plot family-level RPKM counts matrix
Scripts are in the __plot_families/__ folder.
Script __plot_families.sh__ launches __plot_families.R__ that calls __function_plot_contigs_abundance.R__.



### Plot Sankey
Scripts are in the __plot_Sankey/__ folder.
Script __plot_sankey.sh__ launches __plot_sankey.R__ that calls __function_plot_sankey.R__.



### Calculate percent of contigs/VCs/families present in more than half of IVPs
Scripts are in the __numbers_for_paper/__ folder.
Script __calculate_numbers_for_paper.sh__ launches __calculate_numbers_for_paper.R__.
