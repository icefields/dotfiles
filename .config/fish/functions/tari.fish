# Function to compress files and directories
# ex: tari file.txt
# ex: tari dir-name/
# result: files and dirs are compressed into file.txt.tar.gz, dir-name.tar.gz
# -x: Extract files
# extract files in particular directory, for example in /tmp:
# tar -zxvf prog-1-jan-2005.tar.gz -C /tmp
function tari --argument filename
    ~/scripts/shell_common/tari.sh $filename
    ## tar -zcvf "(string replace -a '/' '' $filename).tar.gz" $filename
    #set output_filename (string replace -a '/' '' $filename).tar.gz
    #tar -zcvf $output_filename $filename
end

