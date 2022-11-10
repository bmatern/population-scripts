echo "Running the Haplotype Script"

# A list of the files to process
zipCodes=("Zipcode00.dat" "Zipcode16.dat" "Zipcode23.dat" "Zipcode30.dat" "Zipcode37.dat" "Zipcode44.dat" "Zipcode51.dat" "Zipcode58.dat" "Zipcode65.dat" "Zipcode72.dat" "Zipcode79.dat" "Zipcode86.dat" "Zipcode93.dat" "Zipcode10.dat" "Zipcode17.dat" "Zipcode24.dat" "Zipcode31.dat" "Zipcode38.dat" "Zipcode45.dat" "Zipcode52.dat" "Zipcode59.dat" "Zipcode66.dat" "Zipcode73.dat" "Zipcode80.dat" "Zipcode87.dat" "Zipcode94.dat" "Zipcode11.dat" "Zipcode18.dat" "Zipcode25.dat" "Zipcode32.dat" "Zipcode39.dat" "Zipcode46.dat" "Zipcode53.dat" "Zipcode60.dat" "Zipcode67.dat" "Zipcode74.dat" "Zipcode81.dat" "Zipcode88.dat" "Zipcode95.dat" "Zipcode12.dat" "Zipcode19.dat" "Zipcode26.dat" "Zipcode33.dat" "Zipcode40.dat" "Zipcode47.dat" "Zipcode54.dat" "Zipcode61.dat" "Zipcode68.dat" "Zipcode75.dat" "Zipcode82.dat" "Zipcode89.dat" "Zipcode96.dat" "Zipcode13.dat" "Zipcode20.dat" "Zipcode27.dat" "Zipcode34.dat" "Zipcode41.dat" "Zipcode48.dat" "Zipcode55.dat" "Zipcode62.dat" "Zipcode69.dat" "Zipcode76.dat" "Zipcode83.dat" "Zipcode90.dat" "Zipcode97.dat" "Zipcode14.dat" "Zipcode21.dat" "Zipcode28.dat" "Zipcode35.dat" "Zipcode42.dat" "Zipcode49.dat" "Zipcode56.dat" "Zipcode63.dat" "Zipcode70.dat" "Zipcode77.dat" "Zipcode84.dat" "Zipcode91.dat" "Zipcode98.dat" "Zipcode15.dat" "Zipcode22.dat" "Zipcode29.dat" "Zipcode36.dat" "Zipcode43.dat" "Zipcode50.dat" "Zipcode57.dat" "Zipcode64.dat" "Zipcode71.dat" "Zipcode78.dat" "Zipcode85.dat" "Zipcode92.dat" "Zipcode99.dat")
#zipCodes=("Zipcode10.dat")
zipCodeDir="/home/ben/github/population-scripts/ZipcodeDat/DAT/"
outputSubDir="/home/ben/github/population-scripts/Results/"
haplomatDir="/home/ben/github/Hapl-o-Mat"

# Go to the haplomat directory 
cd $haplomatDir


# Loop
for zipCode in ${zipCodes[*]}; do
  echo $zipCode

  # Modify the .zip code file to change the header names (Replace "A1" with "A" etc)
  zipCodeOrigFilename=$zipCodeDir$zipCode
  zipCodeModifiedFilename=$zipCodeDir"Modified_"$zipCode
  echo "replacing headers...."
  sed 's/\tA1\t/\tA\t/g; s/\tA2\t/\tA\t/g; s/\tB1\t/\tB\t/g; s/\tB2\t/\tB\t/g; s/\tC1\t/\tC\t/g; s/\tC2\t/\tC\t/g; s/\tDRB11\t/\tDRB1\t/g; s/\tDRB12\t/\tDRB1\t/g; s/\tDQB11\t/\tDQB1\t/g; s/\tDQB12\t/\tDQB1\t/g; s/\tDPB11\t/\tDPB1\t/g; s/\tDPB12\t/\tDPB1\t/g' $zipCodeOrigFilename > $zipCodeModifiedFilename

  # make output directory
  outputDirectory=$outputSubDir$zipCode
  mkdir $outputDirectory

  # Output a config file to "parametersMAC"
  echo "Writing the Config File..."  
   
  echo "#file name
FILENAME_INPUT="$zipCodeModifiedFilename"
FILENAME_HAPLOTYPES="$outputDirectory"/haplotypes.dat
FILENAME_GENOTYPES="$outputDirectory"/genotypes.dat
FILENAME_HAPLOTYPEFREQUENCIES="$outputDirectory"/htf.dat
FILENAME_EPSILON_LOGL="$outputDirectory"/epsilon.dat
#reports
LOCI_AND_RESOLUTIONS=A:g,B:g,C:g,DQB1:g,DRB1:g
MINIMAL_FREQUENCY_GENOTYPES=1e-5
DO_AMBIGUITYFILTER=false
EXPAND_LINES_AMBIGUITYFILTER=false
WRITE_GENOTYPES=true
#EM-algorithm
INITIALIZATION_HAPLOTYPEFREQUENCIES=perturbation
EPSILON=1e-6
CUT_HAPLOTYPEFREQUENCIES=1e-6
RENORMALIZE_HAPLOTYPEFREQUENCIES=false
SEED=0" > parametersMAC

  # run Haplomat
  ./haplomat MAC  

done

