#Glanville et al (2021) MetSeq Data Analyses
Updated by Dua on 04/19/2021
###Three parts: 

1- Installations

2- Mapping Tn-Seq Reads to Reference Genome using ```bowtie2```

3- Using Tn-Seq Analysis Software (TSAS) for Met-Seq data manipulation and statistical analyses

4- Getting started with MochiView **(not finished)**

##1) Installations

1. Install Java - if you don't already have it. Open terminal and enter: 
	* For MacOS with Intel processors: 
		
		Install Java here : [https://www.oracle.com/java/technologies/javase-jdk15-downloads.html](https://www.oracle.com/java/technologies/javase-jdk15-downloads.html)
	* For MacOS with M1 chip processors, run the following codes: 	 
		
		```
		$ curl -s "https://get.sdkman.io​" | bash  #install SDK
	
		$ sdk list java #lists the java versions
	
		$ sdk install java 8.0.282-zulu 
		
		$ java -version
		```
 
2. Download the ```MPAO1_genome.fasta``` and ```MPAO1_genome.gff``` files from NCBI ([GenBank: CP027857.1](https://www.ncbi.nlm.nih.gov/nuccore/CP027857.1?report=genbank))
	* To download the FASTA file: 
		* Click on FASTA.   
		* Click on "Send to:"
		* Choose destination to "File"
		* Keep format as "FASTA"
		* Click "create file"

	* To download the GFF file: 
		* Follow the link to "Assembly" under "Related information" in the right-hand sidebar
		* Click on the "Download Assembliy" button to open the download menu
		* Select the "Source database" - GenBank 
		* Download the necessary file

2. Git clone the TSAS git hub repo: [https://github.com/srimam/TSAS](https://github.com/srimam/TSAS)
Keep these files in the same folder you have your genome fasta and TnSeq data files.

3. Install bowtie from conda if you haven't already: 

	```
	$ conda install bowtie2
	```
	
4. Git clone trimgalore:
	```
	$ git clone https://github.com/FelixKrueger/TrimGalore
	
	$ export PATH=/where you cloned the folder/
	/Users/duavang/.sdkman/candidates/java/current/bin:/Users/duavang/opt/anaconda3/bin:/Users/duavang/opt/anaconda3/condabin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/duavang/Desktop/bin/bbmap:/Users/duavang/Desktop/bin/TrimGalore
	
	```
## Map Tn-Seq reads to Reference Genome 
1. Use ```bowtie2``` to index your reference genome: 
 
 Format: ```bowtie2-build <genome fasta file> <output name>```
	
	```
	$ bowtie2-build MPAO1_genome.fasta MPAO_index
	```
	
	This command will compute out several files with the same name in different formats. That is okay - the next few commands will only be using the "base" name of those files. 
	
2. Inspect the index file by running: 
	
	Format: ```bowtie2-inspect [options] <ebwt_base>```

	```
	$ bowtie2-inspect MPAO_index
	```
	**Note:  Only the "basename" of the index is to be inspected. The basename is name of any of the index files but with the .X.ebwt or .rev.X.ebwt suffix omitted. bowtie-inspect first looks in the current directory for the index files, then in the directory specified in the BOWTIE_INDEXES environment variable.**
	
3. Trim your reads: 

	```
	$ trim_galore --length 40 SRR13258538.fastq
	
	```
	
	Your output fill will be a SRR13258538trimmed.fastq file. 
	
4. Map your trimmed TnSeq reads to the indexed genome file: 

	Format: ```bowtie2 [options] -x indexFile fastqFile -S outputFile```
	
	```
	bowtie2 -x MPAO_index SRR13258538t_rimmed.fq -S 538_mapped.bowtie2
	```
	The output in your terminal should tell you the %s that mapped to the reference genome index. I was getting really low %s - not sure if this is also what the paper was seeing as well. Nonetheless, I moved on to the TSAS functions. 
	
	Keep the output file from this command - you will need this to run TSAS. 
	
## 2) Run Tn-Seq Analysis Software (TSAS) V.3.0 on mapped reads for manipulation and statistical analyses
> I have not tried V.3.1. Feel free to explore that version as well
 
7. Fill the "Parameters.txt." Keep most at default. I ran a one sample analysis and changed the threshold of the number of hits to unique insertion site to **10.** See Glanville et al methods - they changed it to 10 as well. I also changed the "results" from default "short" to "long."
([User Guide here ](https://github.com/srimam/TSAS/blob/master/TSAS/V0.3.0/TSAS%20User%20Guide.pdf)) 
	
	```
	#####Input parameters Dua's ex)
	
	##Analysis type (1 - one sample analysis (default); 2 - two sample analysis)
	Analysis_type = 1
	
	##Genome FASTA file [required]
	Genome_sequence = MPAO1_genome.fasta
	
	##Organism GFF file [required]
	GFF = MPAO1_genome.gff
	
	##Mapped reads file format (Bowtie, SOAP or Eland) [required]
	Mapped_format = Bowtie
	
	##Mapped reads files (replicates should be listed sequentially in appropriate group (control or treatment) separated by commas)
	
	#Treatment [required] (if replicate samples are provided, analysis will be averaged over the replicates)
	Treatment = 538_mapped.bowtie2
	
	#Control (this is only used with two sample analysis and will be ignored by one-sample analysis code. For a one-sample, sample(s) should be list under Treatment. If replicate samples are provided, analysis will average over the replicates)
	Control = 
	
	##Threshold for minimum number of hits at a unique insertion site for it to be considered a true site. Default value is 5 hits.
	Min. hits = 10
	
	##Percentage of start and end of gene to be discarded when determining essentiality (a value of 5 equals 5% to be ignored @ start and @ end by default)
	Clipping = 5
	
	##Capping of reads at unique sites to minimize PCR/sequencing bias (0 - no capping; or 1 - capping with average hits per insertion site + 2 st. dev. (default); or 2 - capping with average hits per insertion site; or 3 - capping with median hits per insertion site) - only relevant to 2 sample analysis
	Capping = 1
	
	##Weight reads per gene based on number of unique insertions in a gene (total hits*(unique hits per gene/average unique hits per gene)) 0 - No weights 1 - Weights used (- only relevant to 2 sample analysis)
	Weights = 0
	
	##Transposon sequence specificity (i.e., target sequence of transpson e.g., TA for Mariner transpons). Leave blank from random transposons like Tn5. This is only relevant for one sample analysis.
	Target seq = TA
	
	##Result format (Long or Short)(if Long it provides additional columns for capped and weighted reads, as well as unadjusted pvalues)
	Result = long	
	
	```

7. Run the following code to run TSAS:
	
	```
	$ java TSAS
	
	```
**NOTE: After running this command, the output in your terminal will tell you the number of total number of unique hits, total number of unique hits within genes, and total number of reads within genes. This information is not generated anywhere else, so make sure you copy and paste this into a text file and save it.**

9. During the course of a TSAS analysis, two or more result files are produced. These files include:
	
	* a. WIG files: For each aligned/mapped reads file specified, a WIG format file is produced containing the number of mapped reads per base pair for the entire genome. This file can be loaded into a genome browser, such as MochiView, to visualize the distribution of insertion sites (and number reads at each insertion site) across the genome. The WIG files are named after the aligned reads file from which the data was derived. The WIG files will be located in the same directory as the aligned reads files.
	
		**NOTE: I've tried MochiView and it's a really hard app to navigate - both the app and the manual are outdated. Will need to find one that is more user friendly. I have also explored IGB, IGV, Jbrowse, and Artemis, but these are geared more towards TnSeq data mapping to eukaroyotic genomes. If you'd like to know more, see here: [https://wikis.univ-lille.fr/bilille/_media/report_genome_browser_bilille_jul2019.pdf](https://wikis.univ-lille.fr/bilille/_media/report_genome_browser_bilille_jul2019.pdf)** 
	
	* b. Essential_genes.txt: (one-sample analysis only) This file can be opened in excel and contains a list of all annotated genes in the genome along with all the statistics calculated for each gene from the data provided for a one-sample analysis. This file will be located in the directory from which TSAS is called. This file has the following columns:
		
		1. **Gene ID:** the unique ID for each gene obtained from the provided GFF file.
		2. **Annotation:** the annotation for each gene obtained from the provided GFF file.
		3. **Gene length (bp):** the length of each gene in base pairs.
		4. **No. of Unique hits:** the number of unique insertion sites for each gene.
		5. **Normalize Unique hits (hits/bp):** the number of unique insertion sites for each gene normalized to the length of the gene.
		6. **Total number of reads:** total number of reads for each gene.
		7. **Pvalue (Essential):** The unadjusted p-values calculated from a binomial distribution
		assessing the likelihood of essentiality of each gene. (Omitted from short results
		output).
		8. **Adj. Pvalue (Essential):** p-values from column 7 corrected for multiple testing using
		the Benjamini-Hochberg (BH) method.
		9. **FWER (Essential):** the family wide error rate calculated from p-values in column 7
		(Bonferroni correction).
		10. **Pvalue (Improved fitness):** The unadjusted p-values calculated from a binomial
		distribution assessing the likelihood of genes whose disruption by transposon insertions may result in an overall improvement of fitness. (Omitted from short results output).
		11. **Adj. Pvalue (Improved fitness):** p-values from column 10 corrected for multiple testing using the BH method.
		12. **FWER (Improved fitness):** the family wide error rate calculated from p-values in column 10 (Bonferroni correction).

## 3. Getting started with MochiView and maaping the aligned/mapped reads.

1. Download MochiView from here: [http://www.johnsonlab.ucsf.edu/mochiview-downloads](http://www.johnsonlab.ucsf.edu/mochiview-downloads)
	
	Manual can be found here: [https://static1.squarespace.com/static/56463117e4b0770d2cd2d163/t/564bbbb1e4b0c03db1589e9a/1447803825330/MochiView_Manual_v1.45.pdf](https://static1.squarespace.com/static/56463117e4b0770d2cd2d163/t/564bbbb1e4b0c03db1589e9a/1447803825330/MochiView_Manual_v1.45.pdf)

2. Open MochiView zip file. (Note make sure you have Java installed, otherwise MochiView will not work).

3. Launch MochiView:
	* If the following message pops up: “MochiView” cannot be opened because the developer cannot be verified" - do the following:
		* right click --> open. This will force the app to open
		* If it still doesn't work, try this: 
			* right click on MochiView --> Show Package Contents --> Contents --> Resources --> JAVA --> Right click on ChipView.jar --> Open with Java. 
	

4. Once in the MochiView app, import the MPAO1 reference genome fasta file as a Sequence Set. Select "Unlisted Species." Then load files. [NOTE: With this interface, it...]

####As you can see... this is where I stopped. Feel free to explore and play around with MochiView if you'd like. I'm going to try and find other alternatives. TnSeq-Explorer utilizes R to do the statistical analyses - that might be an option for us.  